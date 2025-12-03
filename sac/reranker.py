"""Placeholder SQL reranker using SAC scores."""
from __future__ import annotations

from typing import List

from utils.logger import get_logger

logger = get_logger()


def rerank_sql_candidates(candidates: List[str]) -> List[str]:
    """Return candidates in the same order with logging for future SAC integration."""
    logger.log_info(
        "Reranking SQL candidates (placeholder).",
        extra={"num_candidates": len(candidates)},
    )
    return candidates


__all__ = ["rerank_sql_candidates"]
