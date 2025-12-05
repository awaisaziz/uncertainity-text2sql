"""Offline SQL reranking using semantic consensus and GMM confidence."""
from __future__ import annotations

import argparse
import json
import logging
from pathlib import Path
from typing import Dict, List, Optional, Sequence

import numpy as np
from scipy.special import softmax
from sentence_transformers import SentenceTransformer
from sklearn.mixture import GaussianMixture

TEMPERATURE = 10.0
HYBRID_ALPHA = 0.5


def cosine_similarity(a: np.ndarray, b: np.ndarray) -> float:
    a_norm = np.linalg.norm(a)
    b_norm = np.linalg.norm(b)
    if a_norm == 0.0 or b_norm == 0.0:
        return 0.0
    return float(np.dot(a, b) / (a_norm * b_norm))


def entropy(probs: Sequence[float]) -> float:
    probs_array = np.asarray(probs, dtype=np.float64)
    clipped = np.clip(probs_array, 1e-12, 1.0)
    return float(-np.sum(probs_array * np.log(clipped)))


def gmm_posteriors(consensus_scores: np.ndarray) -> np.ndarray:
    gmm = GaussianMixture(n_components=2, random_state=42)
    reshaped = consensus_scores.reshape(-1, 1)
    gmm.fit(reshaped)
    means = gmm.means_.flatten()
    good_idx = int(np.argmax(means))
    posteriors = gmm.predict_proba(reshaped)[:, good_idx]
    return posteriors


def rerank_question(
    entry: Dict, model: SentenceTransformer, logger: Optional[logging.Logger] = None
) -> Dict:
    logger = logger or logging.getLogger("text2sql")
    question_text = entry["question"]
    candidates = entry.get("candidates", [])
    if not candidates:
        return {
            **entry,
            "candidates": [],
            "semantic_entropy": 0.0,
            "gmm_entropy": 0.0,
            "selected_sql_softmax": None,
            "selected_sql_gmm": None,
            "selected_sql_hybrid": None,
        }

    question_embedding = model.encode(question_text, normalize_embeddings=False, convert_to_numpy=True)
    sql_texts = [cand["sql"] for cand in candidates]
    sql_embeddings = model.encode(sql_texts, normalize_embeddings=False, convert_to_numpy=True)

    cos_scores: List[float] = [
        cosine_similarity(question_embedding, sql_embedding)
        for sql_embedding in sql_embeddings
    ]

    mean_embedding = np.mean(sql_embeddings, axis=0)
    consensus_scores: List[float] = [cosine_similarity(sql_emb, mean_embedding) for sql_emb in sql_embeddings]

    softmax_probs = softmax(np.array(consensus_scores) * TEMPERATURE)
    gmm_scores = gmm_posteriors(np.array(consensus_scores))

    semantic_entropy = entropy(softmax_probs)
    gmm_entropy_value = entropy(gmm_scores)

    hybrid_scores = HYBRID_ALPHA * softmax_probs + (1 - HYBRID_ALPHA) * gmm_scores

    softmax_idx = int(np.argmax(softmax_probs))
    gmm_idx = int(np.argmax(gmm_scores))
    hybrid_idx = int(np.argmax(hybrid_scores))

    selected_sql_softmax = sql_texts[softmax_idx]
    selected_sql_gmm = sql_texts[gmm_idx]
    selected_sql_hybrid = sql_texts[hybrid_idx]

    logger.info(
        "Question: %s | Softmax: %s | GMM: %s | Hybrid: %s",
        question_text,
        selected_sql_softmax,
        selected_sql_gmm,
        selected_sql_hybrid,
    )

    enriched_candidates = []
    for sql_text, cos_sim, consensus, softmax_prob, gmm_post in zip(
        sql_texts, cos_scores, consensus_scores, softmax_probs, gmm_scores
    ):
        enriched_candidates.append(
            {
                "sql": sql_text,
                "cosine_similarity": float(cos_sim),
                "consensus_score": float(consensus),
                "softmax_prob": float(softmax_prob),
                "gmm_posterior": float(gmm_post),
            }
        )

    return {
        "id": entry.get("id"),
        "question": question_text,
        "db_id": entry.get("db_id"),
        "candidates": enriched_candidates,
        "semantic_entropy": float(semantic_entropy),
        "gmm_entropy": float(gmm_entropy_value),
        "selected_sql_softmax": selected_sql_softmax,
        "selected_sql_gmm": selected_sql_gmm,
        "selected_sql_hybrid": selected_sql_hybrid,
    }


def run_reranking(
    input_path: Path, output_path: Path, logger: Optional[logging.Logger] = None
) -> None:
    if logger is None:
        logging.basicConfig(level=logging.INFO)
        logger = logging.getLogger("text2sql")
    input_path = Path(input_path)
    output_path = Path(output_path)
    with input_path.open("r", encoding="utf-8") as f:
        input_payload = json.load(f)

    model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")

    generated_entries = input_payload.get("generated", [])
    reranked_entries = [
        rerank_question(entry, model, logger=logger) for entry in generated_entries
    ]

    output_payload = {
        "dataset_path": input_payload.get("dataset_path"),
        "default_provider": input_payload.get("default_provider"),
        "default_model": input_payload.get("default_model"),
        "mode": "rerank",
        "num_sample": input_payload.get("num_sample"),
        "num_query": input_payload.get("num_query"),
        "max_tokens": input_payload.get("max_tokens"),
        "generated": reranked_entries,
    }

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8") as f:
        json.dump(output_payload, f, indent=2)

    if output_path.name != "reranked_output.json":
        alias_path = output_path.parent / "reranked_output.json"
        with alias_path.open("w", encoding="utf-8") as alias_file:
            json.dump(output_payload, alias_file, indent=2)

    logger.info("Reranked output written to %s", output_path)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Rerank DeepSeek SQL candidates.")
    parser.add_argument("--input", dest="input_path", type=Path, required=True, help="Path to generated LLM output JSON.")
    parser.add_argument(
        "--output",
        dest="output_path",
        type=Path,
        default=Path("outputs/reranked/reranked_output.json"),
        help="Path to write reranked JSON output.",
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    run_reranking(args.input_path, args.output_path)
