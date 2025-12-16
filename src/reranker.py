"""
Robust Semantic SQL Reranking - Softmax + Execution + gte-large + 2D GMM + Hybrid
"""

import argparse
import json
import logging
from pathlib import Path
from typing import Dict, List, Optional, Sequence
import sqlite3
from collections import defaultdict

import numpy as np
from scipy.special import softmax as scipy_softmax
from sentence_transformers import SentenceTransformer
from sklearn.mixture import GaussianMixture
import torch

# -----------------------------
# Hyperparameters
# -----------------------------
TEMPERATURE = 9.0
MIN_EXECUTION_TRUST = 0.7   # >= 30% agreement to trust execution

W_QSS = 0.7
W_CSA = 0.3

HYBRID_SOFT = 0.3
HYBRID_GMM = 0.2
HYBRID_EXEC = 0.5


# -----------------------------
# Utilities
# -----------------------------
def cosine_similarity(a: np.ndarray, b: np.ndarray) -> float:
    a_norm = np.linalg.norm(a); b_norm = np.linalg.norm(b)
    if a_norm == 0 or b_norm == 0: return 0.0
    return float(np.dot(a, b) / (a_norm * b_norm))


def entropy(probs: Sequence[float]) -> float:
    probs = np.clip(probs, 1e-12, 1)
    return float(-np.sum(probs * np.log(probs)))


def execute_semantic_key(sql: str, db_id: str, db_root="spider/database") -> tuple:
    try:
        db = f"{db_root}/{db_id}/{db_id}.sqlite"
        conn = sqlite3.connect(db)
        cur = conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()
        conn.close()
        return frozenset(tuple(r) for r in rows)
    except:
        return "ERROR"


def normalize_sql_for_embedding(sql: str) -> str:
    sql = sql.strip().rstrip(";")
    sql = " ".join(sql.split())
    return sql.replace('"', "'")


# -----------------------------
# New 2D Optimized GMM
# -----------------------------
def optimized_gmm_scores_2d(qss_arr: np.ndarray, csa_arr: np.ndarray) -> np.ndarray:
    """
    GMM over 2D semantic feature vector [QSS, CSA].
    Returns: posterior probability of belonging to the "good" semantic cluster.
    """
    K = len(qss_arr)
    if K == 1:
        return np.ones(1, dtype=np.float32)

    X = np.stack([qss_arr, csa_arr], axis=1).astype(np.float32)

    # Degenerate constant cases
    if np.std(X) < 1e-6:
        return np.ones(K, dtype=np.float32) * 0.5

    unique_vals = np.unique(np.round(X, 6), axis=0)
    if len(unique_vals) < 2:
        return np.ones(K, dtype=np.float32) * 0.5

    gmm = GaussianMixture(
        n_components=2,
        covariance_type="full",
        reg_covar=1e-3,
        random_state=42
    )
    gmm.fit(X)

    means = gmm.means_[:, 0] + gmm.means_[:, 1]   # heuristic: higher QSS+CSA = better
    good_idx = int(np.argmax(means))

    post = gmm.predict_proba(X)[:, good_idx]
    return post.astype(np.float32)


# -----------------------------
# Semantic reranking (2D GMM)
# -----------------------------
def semantic_rerank(question: str, sql_list: List[str], model: SentenceTransformer) -> Dict:

    K = len(sql_list)
    if K == 0:
        return {
            "selected_sql_softmax": None,
            "selected_sql_gmm": None,
            "semantic_entropy_softmax": 0,
            "semantic_entropy_gmm": 0,
            "gmm_entropy": 0,
            "qss": [], "csa": [], "combined": [],
            "softmax_probs": [], "gmm_weighted_probs": [], "gmm_scores": [],
        }

    q_emb = model.encode(question, normalize_embeddings=True)
    sql_norm = [normalize_sql_for_embedding(x) for x in sql_list]
    sql_emb = model.encode(sql_norm, normalize_embeddings=True)

    # --- 1) Question-SQL Similarity (QSS) ---
    qss = np.array([cosine_similarity(q_emb, s) for s in sql_emb], dtype=np.float32)

    # --- 2) Cross-Semantic Agreement (CSA) ---
    sim = sql_emb @ sql_emb.T
    np.fill_diagonal(sim, 0)
    csa = np.array([(sim[i].sum() / (K-1)) if K>1 else 1.0 for i in range(K)], dtype=np.float32)

    # --- 3) Scalar combined feature used for logits ---
    combined_scalar = W_QSS * qss + W_CSA * csa

    # --- 4) Baseline softmax ---
    logits = combined_scalar * TEMPERATURE
    softmax_probs = scipy_softmax(logits)
    best_soft = int(np.argmax(softmax_probs))

    # --- 5) 2D GMM over raw [QSS, CSA] ---
    gmm_scores = optimized_gmm_scores_2d(qss, csa)
    gmm_entropy = entropy(gmm_scores)

    # --- 6) GMM-weighted logits ---
    gmm_logits = (combined_scalar * gmm_scores) * TEMPERATURE
    gmm_probs = scipy_softmax(gmm_logits)
    best_gmm = int(np.argmax(gmm_probs))

    return {
        "selected_sql_softmax": sql_list[best_soft],
        "selected_sql_gmm": sql_list[best_gmm],
        "semantic_entropy_softmax": float(entropy(softmax_probs)),
        "semantic_entropy_gmm": float(entropy(gmm_probs)),
        "gmm_entropy": float(gmm_entropy),
        "qss": qss.tolist(),
        "csa": csa.tolist(),
        "combined": combined_scalar.tolist(),
        "softmax_probs": softmax_probs.tolist(),
        "gmm_weighted_probs": gmm_probs.tolist(),
        "gmm_scores": gmm_scores.tolist(),
        "best_idx_softmax": best_soft,
        "best_idx_gmm": best_gmm,
    }

# -----------------------------
# Full reranking for one entry (execution + semantic + hybrid)
# -----------------------------
def rerank_question(
    entry: Dict,
    model: SentenceTransformer,
    db_root: str,
    logger: Optional[logging.Logger] = None,
) -> Dict:
    """
    Rerank one question's SQL candidates using a 3-tier strategy:

    1) Execution consensus (if >= MIN_EXECUTION_TRUST)
    2) Hybrid semantic fallback combining:
         - semantic softmax probability
         - GMM-based semantic probability
         - execution agreement weights
    3) GMM + softmax metrics are still returned for analysis, but
       the final robust choice is either:
         - execution_consensus
         - semantic_hybrid
    """
    logger = logger or logging.getLogger("text2sql")
    question_text = entry["question"]
    db_id = entry["db_id"]
    candidates = entry.get("candidates", [])

    if not candidates:
        # No candidates return placeholder metrics
        return {
            **entry,
            "candidates": [],
            "semantic_entropy_softmax": 0.0,
            "semantic_entropy_gmm": 0.0,
            "semantic_entropy_hybrid": 0.0,
            "gmm_entropy": 0.0,
            "true_semantic_entropy": 0.0,
            "selected_sql_softmax": None,
            "selected_sql_gmm": None,
            "selected_sql_hybrid": None,
            "selected_sql_robust": None,
            "selection_method": "none",
            "execution_trust": 0.0,
            "num_exec_errors": 0,
        }

    sql_texts = [cand["sql"] for cand in candidates]

    # ============================== 1. EXECUTION-GUIDED (PRIMARY) ==============================
    exec_clusters = defaultdict(list)  # result_key -> list of candidate dicts
    error_count = 0
    result_keys: List = []

    for cand in candidates:
        sql = cand["sql"]
        result_key = execute_semantic_key(sql, db_id, db_root)
        result_keys.append(result_key)

        if result_key == "ERROR":
            error_count += 1
        exec_clusters[result_key].append(cand)

    # --- True semantic entropy from execution clusters ---
    # We treat "ERROR" as one cluster as well, so this entropy measures
    # how dispersed the execution behavior is across candidates.
    exec_cluster_sizes = [len(cluster) for cluster in exec_clusters.values()]
    exec_probs = np.array(exec_cluster_sizes) / len(candidates)
    true_semantic_entropy = float(
        -np.sum(exec_probs * np.log(exec_probs + 1e-12))
    )

    # --- Identify valid (non-error) result clusters ---
    valid_clusters = {k: v for k, v in exec_clusters.items() if k != "ERROR"}

    # Overall execution trust = size of the largest valid cluster / total candidates
    execution_trust = 0.0
    selected_sql_robust: Optional[str] = None
    selection_method: str = "semantic_hybrid"  # default fallback

    # Execution consensus decision
    if valid_clusters:
        best_exec_key = max(valid_clusters, key=lambda k: len(valid_clusters[k]))
        execution_trust = len(valid_clusters[best_exec_key]) / len(candidates)
        if execution_trust >= MIN_EXECUTION_TRUST:
            # Trust execution majority - pick the first from largest valid cluster
            selected_sql_robust = valid_clusters[best_exec_key][0]["sql"]
            selection_method = "execution_consensus"
            logger.info(
                f"EXEC WIN: {question_text[:55]}... | Ratio: {execution_trust:.2f}"
            )

    # --- Per-candidate execution agreement weights for hybrid (even if below threshold) ---
    # For each candidate, define w_i = cluster_size / K if non-error, else 0.
    exec_weights: List[float] = []
    if valid_clusters:
        for rkey in result_keys:
            if rkey == "ERROR" or rkey not in valid_clusters:
                exec_weights.append(0.0)
            else:
                exec_weights.append(
                    len(valid_clusters[rkey]) / len(candidates)
                )
    else:
        # No valid clusters at all weights 0.0
        exec_weights = [0.0 for _ in candidates]

    # ============================== 2. OPTIMIZED SEMANTIC + GMM ===============================
    semantic_info = semantic_rerank(question_text, sql_texts, model)

    selected_sql_softmax = semantic_info["selected_sql_softmax"]
    selected_sql_gmm = semantic_info["selected_sql_gmm"]

    softmax_probs = semantic_info["softmax_probs"]
    gmm_weighted_probs = semantic_info["gmm_weighted_probs"]

    # ============================== 3. HYBRID FUSION (H1) =====================================
    # Hybrid score combines:
    #   H_i = a * p_softmax_i + b * p_gmm_i + g * execution_weight_i
    # Then we apply a softmax over H for a proper probability distribution.
    hybrid_raw = np.array(
        [
            HYBRID_SOFT * p_soft
            + HYBRID_GMM * p_gmm
            + HYBRID_EXEC * w_exec
            for p_soft, p_gmm, w_exec in zip(
                softmax_probs, gmm_weighted_probs, exec_weights
            )
        ],
        dtype=np.float32,
    )

    hybrid_probs = scipy_softmax(hybrid_raw)
    best_idx_hybrid = int(np.argmax(hybrid_probs))
    selected_sql_hybrid = sql_texts[best_idx_hybrid]
    semantic_entropy_hybrid = entropy(hybrid_probs)

    # If execution didn't win, use hybrid semantic selection
    if selected_sql_robust is None:
        selected_sql_robust = selected_sql_hybrid
        selection_method = "semantic_hybrid"

    # ============================== ENRICHED PER-CANDIDATE OUTPUT =============================
    hybrid_raw_list = hybrid_raw.tolist()
    hybrid_probs_list = hybrid_probs.tolist()

    enriched_candidates = []
    for (
        sql_text,
        qss,
        csa,
        comb,
        p_soft,
        p_gmm_w,
        gmm_score,
        w_exec,
        h_raw,
        h_prob,
    ) in zip(
        sql_texts,
        semantic_info["qss"],
        semantic_info["csa"],
        semantic_info["combined"],
        semantic_info["softmax_probs"],
        semantic_info["gmm_weighted_probs"],
        semantic_info["gmm_scores"],
        exec_weights,
        hybrid_raw_list,
        hybrid_probs_list,
    ):
        enriched_candidates.append(
            {
                "sql": sql_text,
                # Semantic features
                "qss": float(qss),
                "csa": float(csa),
                "combined_feature": float(comb),
                # Pure semantic softmax
                "softmax_prob": float(p_soft),
                # GMM-enhanced semantic probability
                "gmm_weighted_prob": float(p_gmm_w),
                "gmm_posterior": float(gmm_score),
                # Execution agreement signal for this candidate
                "execution_weight": float(w_exec),
                # Hybrid fusion diagnostics
                "hybrid_score": float(h_raw),
                "hybrid_prob": float(h_prob),
            }
        )

    # ============================== FINAL PACKAGED OUTPUT =====================================
    return {
        "id": entry.get("id"),
        "question": question_text,
        "db_id": db_id,
        "candidates": enriched_candidates,
        # Entropies / uncertainty metrics
        "semantic_entropy_softmax": float(semantic_info["semantic_entropy_softmax"]),
        "semantic_entropy_gmm": float(semantic_info["semantic_entropy_gmm"]),
        "semantic_entropy_hybrid": float(semantic_entropy_hybrid),
        "gmm_entropy": float(semantic_info["gmm_entropy"]),
        "true_semantic_entropy": float(true_semantic_entropy),
        # Individual selector outputs
        "selected_sql_softmax": selected_sql_softmax,
        "selected_sql_gmm": selected_sql_gmm,
        "selected_sql_hybrid": selected_sql_hybrid,
        # MAIN robust output (execution if possible, otherwise hybrid)
        "selected_sql_robust": selected_sql_robust,
        "selection_method": selection_method,
        "execution_trust": float(execution_trust),
        "num_exec_errors": error_count,
        # Extra hybrid diagnostics for analysis
        "hybrid_probs": [float(x) for x in hybrid_probs_list],
        "hybrid_scores": [float(x) for x in hybrid_raw_list],
        "best_idx_hybrid": best_idx_hybrid,
    }


# -----------------------------
# Rerank all questions in file
# -----------------------------
def run_reranking(
    input_path: Path,
    output_path: Path,
    db_root: str,
    logger: Optional[logging.Logger] = None,
) -> None:
    """
    Entry point for processing a JSON file containing generated SQL candidates.

    It loads the sentence embedding model, reranks all questions, and writes
    out a rich JSON structure containing:
      - enriched per-candidate diagnostics
      - multiple entropy measures
      - semantic, GMM, hybrid, and robust selections
    """
    if logger is None:
        logging.basicConfig(level=logging.INFO)
        logger = logging.getLogger("text2sql")

    input_path = Path(input_path)
    output_path = Path(output_path)

    with input_path.open("r", encoding="utf-8") as f:
        input_payload = json.load(f)

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    logger.info(f"Loading thenlper/gte-large model on {device}")
    model = SentenceTransformer("thenlper/gte-large", device=device)

    generated_entries = input_payload.get("generated", [])
    logger.info(f"Processing {len(generated_entries)} questions")

    reranked_entries = [
        rerank_question(entry, model, db_root, logger=logger)
        for entry in generated_entries
    ]

    output_payload = {
        "dataset_path": input_payload.get("dataset_path"),
        "default_provider": input_payload.get("default_provider"),
        "default_model": input_payload.get("default_model"),
        "mode": "robust_semantic_gmm_hybrid",  # updated mode label
        "db_root": db_root,
        "num_sample": input_payload.get("num_sample"),
        "num_query": input_payload.get("num_query"),
        "max_tokens": input_payload.get("max_tokens"),
        "generated": reranked_entries,
    }

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8") as f:
        json.dump(output_payload, f, indent=2)

    # Stats: how often execution fully wins
    exec_wins = sum(
        1 for e in reranked_entries if e["selection_method"] == "execution_consensus"
    )
    logger.info(
        f"EXECUTION WINS: {exec_wins}/{len(reranked_entries)} "
        f"({exec_wins/len(reranked_entries)*100:.1f}%)"
    )
    logger.info("Reranked output written to %s", output_path)


# -----------------------------
# CLI
# -----------------------------
def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Robust Semantic SQL Reranking (Execution + Optimized GMM).")
    parser.add_argument(
        "--input",
        dest="input_path",
        type=Path,
        required=True,
        help="Path to generated LLM output JSON.",
    )
    parser.add_argument(
        "--output",
        dest="output_path",
        type=Path,
        default=Path("outputs/reranked/reranked_output.json"),
        help="Path to write reranked JSON output.",
    )
    parser.add_argument(
        "--db_root",
        dest="db_root",
        type=str,
        default="spider_data/database",
        help="Root folder for Spider DBs (default: spider_data/database)",
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    run_reranking(args.input_path, args.output_path, args.db_root)
