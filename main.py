"""Entry point helper for the text-to-SQL project."""
from __future__ import annotations

from config import defaults
from utils.logger import get_logger

logger = get_logger()


def describe():
    """Provide a quick description of how to run the CLI."""
    logger.log_info(
        "Use cli.py to run text-to-sql generation.",
        extra={
            "example": "python cli.py --dataset data/dev.json --technique zeroshot --provider deepseek --model deepseek-chat",
            "defaults": {
                "provider": defaults.get_default_provider(),
                "model": defaults.get_default_model(),
                "dataset": defaults.get_default_dataset_path(),
            },
        },
    )


if __name__ == "__main__":
    describe()
