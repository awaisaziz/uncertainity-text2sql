"""Robust Semantic SQL Reranking - Execution + gte-large + Optimized GMM + Hybrid"""

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
TEMPERATURE = 8.0
MIN_EXECUTION_TRUST = 0.2  # >= 20% agreement trust execution

# Semantic feature mixing for GMM
W_QSS = 0.3   # weight for Question-SQL similarity
W_CSA = 0.7   # weight for cross-sample agreement

# Hybrid fusion weights (H1: softmax + GMM + execution)
HYBRID_ALPHA = 0.2  # weight for semantic softmax probability
HYBRID_BETA = 0.3   # weight for GMM-weighted semantic probability
HYBRID_GAMMA = 0.5  # weight for execution agreement


# -----------------------------
# Utility Functions
# -----------------------------
def cosine_similarity(a: np.ndarray, b: np.ndarray) -> float:
    """Cosine similarity between two vectors with safety for zero-norm vectors."""
    a_norm = np.linalg.norm(a)
    b_norm = np.linalg.norm(b)
    if a_norm == 0.0 or b_norm == 0.0:
        return 0.0
    return float(np.dot(a, b) / (a_norm * b_norm))


def entropy(probs: Sequence[float]) -> float:
    """
    Standard Shannon entropy over a probability distribution.

    We clip probabilities for numerical stability (avoid log(0)).
    """
    probs_array = np.asarray(probs, dtype=np.float64)
    clipped = np.clip(probs_array, 1e-12, 1.0)
    return float(-np.sum(clipped * np.log(clipped)))


def execute_semantic_key(sql: str, db_id: str, db_root: str = "spider/database") -> tuple:
    """
    Execute SQL against a Spider-style SQLite DB and return a hashable "semantic key".

    - On success: returns a frozenset of result rows (tuples) so that
      semantically identical results collapse into the same cluster.
    - On error: returns the string "ERROR".
    """
    try:
        db_path = f"{db_root}/{db_id}/{db_id}.sqlite"
        conn = sqlite3.connect(db_path)
        conn.execute("PRAGMA foreign_keys = ON;")
        cursor = conn.cursor()
        cursor.execute(sql)
        results = cursor.fetchall()
        conn.close()
        # Make hashable frozenset of tuples
        return frozenset(tuple(row) for row in results)
    except Exception:
        return "ERROR"


def normalize_sql_for_embedding(sql: str) -> str:
    """
    Light SQL normalization to get more stable sentence embeddings.

    - Trims trailing semicolons
    - Normalizes whitespace
    - Normalizes double quotes to single quotes
    """
    sql = sql.strip().rstrip(";")
    sql = " ".join(sql.split())  # normalize whitespace
    sql = sql.replace('"', "'")  # normalize quotes
    return sql


# -----------------------------
# Optimized GMM on semantic feature
# -----------------------------
def optimized_gmm_scores(combined_feature: np.ndarray) -> np.ndarray:
    """
    Fit a regularized 2-component GMM on a 1D combined semantic feature vector z,
    and return the posterior probability of belonging to the "good" component.

    The assumption is that z is approximately bimodal:
    - one mode for semantically "good" SQL candidates
    - one mode for semantically "bad" candidates
    """
    if combined_feature.shape[0] == 1:
        # Only one candidate no mixture full confidence
        return np.ones_like(combined_feature, dtype=np.float32)
    
    # Normalize the feature
    std = np.std(combined_feature)
    if std < 1e-6:
        # Degenerate case: no identifiable clusters
        # Return neutral confidence
        return np.ones_like(combined_feature, dtype=np.float32) * 0.5
    
    # Normalize to spread distribution before fitting GMM
    z = (combined_feature - combined_feature.mean()) / (combined_feature.std() + 1e-6)
    z = z.reshape(-1, 1)
    
    # Determine the number of distinct values
    unique_vals = np.unique(np.round(z, decimals=6))

    if len(unique_vals) < 2:
        # Only 1 distinct cluster cannot fit 2 GMM components
        return np.ones_like(combined_feature, dtype=np.float32) * 0.5

    gmm = GaussianMixture(
        n_components=2,
        covariance_type="diag",
        reg_covar=1e-3,
        random_state=42,
    )
    gmm.fit(z)

    # The component with higher mean is treated as the "good" semantic region
    means = gmm.means_.flatten()
    good_idx = int(np.argmax(means))

    posteriors = gmm.predict_proba(z)[:, good_idx]
    return posteriors.astype(np.float32)


# -----------------------------
# Semantic reranking for one question (no execution info here)
# -----------------------------
def semantic_rerank(
    question_text: str,
    sql_texts: List[str],
    model: SentenceTransformer,
) -> Dict:
    """
    Compute semantic scores for candidates using:
      - QSS: question-SQL similarity (cosine)
      - CSA: pairwise cross-sample agreement (mean embedding similarity)
      - Combined feature z = W_QSS * QSS + W_CSA * CSA
      - Baseline softmax over z
      - GMM over z (optimized), then softmax on GMM-weighted logits

    Returns dict with:
      - selected_sql_softmax, selected_sql_gmm
      - semantic_entropy_softmax, semantic_entropy_gmm, gmm_entropy
      - per-candidate arrays: qss, csa, combined, softmax_probs,
        gmm_weighted_probs, gmm_scores, indices.
    """
    K = len(sql_texts)
    if K == 0:
        return {
            "selected_sql_softmax": None,
            "selected_sql_gmm": None,
            "semantic_entropy_softmax": 0.0,
            "semantic_entropy_gmm": 0.0,
            "gmm_entropy": 0.0,
            "qss": [],
            "csa": [],
            "combined": [],
            "softmax_probs": [],
            "gmm_weighted_probs": [],
            "gmm_scores": [],
            "best_idx_softmax": None,
            "best_idx_gmm": None,
        }

    # ----- Embeddings -----
    q_emb = model.encode(
        question_text,
        normalize_embeddings=True,
        convert_to_numpy=True,
    )
    sql_norm = [normalize_sql_for_embedding(sql) for sql in sql_texts]
    sql_embs = model.encode(
        sql_norm,
        normalize_embeddings=True,
        convert_to_numpy=True,
    )

    # ----- QSS: question-SQL similarity -----
    qss = [cosine_similarity(q_emb, s_emb) for s_emb in sql_embs]

    # ----- CSA: pairwise cross-sample agreement -----
    # Using dot product since embeddings are L2-normalized cosine similarity
    sim_matrix = sql_embs @ sql_embs.T
    np.fill_diagonal(sim_matrix, 0.0)
    if K > 1:
        csa = (sim_matrix.sum(axis=1) / (K - 1)).tolist()
    else:
        csa = [1.0]  # neutral if only one candidate

    # ----- Combined semantic feature z = W_QSS * QSS + W_CSA * CSA -----
    combined = np.array(
        [W_QSS * q + W_CSA * c for q, c in zip(qss, csa)],
        dtype=np.float32,
    )

    # ----- Baseline semantic softmax (no GMM) over logits = combined * TEMPERATURE -----
    baseline_logits = combined * TEMPERATURE
    softmax_probs = scipy_softmax(baseline_logits)
    best_idx_softmax = int(np.argmax(softmax_probs))
    selected_sql_softmax = sql_texts[best_idx_softmax]
    semantic_entropy_softmax = entropy(softmax_probs)

    # ----- Optimized GMM on combined feature -----
    gmm_scores = optimized_gmm_scores(combined)  # posterior over "good" component
    gmm_entropy_value = entropy(gmm_scores)

    # ----- GMM-weighted logits and softmax -----
    gmm_weighted_logits = combined * gmm_scores
    gmm_weighted_logits_scaled = gmm_weighted_logits * TEMPERATURE
    gmm_weighted_probs = scipy_softmax(gmm_weighted_logits_scaled)
    best_idx_gmm = int(np.argmax(gmm_weighted_probs))
    selected_sql_gmm = sql_texts[best_idx_gmm]
    semantic_entropy_gmm = entropy(gmm_weighted_probs)

    return {
        "selected_sql_softmax": selected_sql_softmax,
        "selected_sql_gmm": selected_sql_gmm,
        "semantic_entropy_softmax": float(semantic_entropy_softmax),
        "semantic_entropy_gmm": float(semantic_entropy_gmm),
        "gmm_entropy": float(gmm_entropy_value),
        "qss": [float(x) for x in qss],
        "csa": [float(x) for x in csa],
        "combined": [float(x) for x in combined],
        "softmax_probs": [float(x) for x in softmax_probs],
        "gmm_weighted_probs": [float(x) for x in gmm_weighted_probs],
        "gmm_scores": [float(x) for x in gmm_scores],
        "best_idx_softmax": best_idx_softmax,
        "best_idx_gmm": best_idx_gmm,
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
            HYBRID_ALPHA * p_soft
            + HYBRID_BETA * p_gmm
            + HYBRID_GAMMA * w_exec
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
    logger.info(f"Loading gte-large model on {device}")
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
        f"✅ EXECUTION WINS: {exec_wins}/{len(reranked_entries)} "
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
