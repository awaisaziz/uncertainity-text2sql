"""Placeholder embedding model for triplet loss training."""
from __future__ import annotations

from utils.logger import get_logger

logger = get_logger()


class TripletEmbeddingModel:
    """Stub for triplet-loss-based embedding model."""

    def __init__(self) -> None:
        logger.log_info("Triplet embedding model initialized (placeholder).")

    def encode(self, text: str) -> list[float]:
        """Return a dummy embedding vector."""
        embedding = [0.0, 0.0, 0.0]
        logger.log_info("Generated placeholder embedding.", extra={"text": text, "embedding": embedding})
        return embedding


__all__ = ["TripletEmbeddingModel"]
