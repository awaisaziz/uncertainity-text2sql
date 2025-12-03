"""Placeholder loader for the Spider dataset."""
from __future__ import annotations

import json
from pathlib import Path
from typing import List, Dict, Any

from utils.logger import get_logger

logger = get_logger()


# Dataset stored externally. See data/README.md for link.

def load_spider_dataset(dataset_path: str) -> List[Dict[str, Any]]:
    path = Path(dataset_path)
    if not path.exists():
        logger.log_info("Dataset path does not exist; returning empty list.", extra={"path": dataset_path})
        return []
    with path.open("r", encoding="utf-8") as f:
        data = json.load(f)
    logger.log_info("Loaded dataset.", extra={"path": dataset_path, "num_records": len(data)})
    return data


__all__ = ["load_spider_dataset"]
