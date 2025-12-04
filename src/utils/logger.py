import logging
from pathlib import Path

LOG_FORMAT = "%(asctime)s - %(levelname)s:%(name)s:%(message)s"


def get_logger(log_dir: Path, log_name: str = "app.log", level: int = logging.INFO) -> logging.Logger:
    """Configure a single log file for the current run."""

    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / log_name

    logger = logging.getLogger("text2sql")
    logger.setLevel(level)
    logger.propagate = False

    # Ensure a clean slate so we don't duplicate handlers across sessions.
    if logger.handlers:
        logger.handlers.clear()

    file_handler = logging.FileHandler(log_file, mode="w", encoding="utf-8")
    file_handler.setFormatter(logging.Formatter(LOG_FORMAT))
    logger.addHandler(file_handler)

    stream_handler = logging.StreamHandler()
    stream_handler.setFormatter(logging.Formatter(LOG_FORMAT))
    logger.addHandler(stream_handler)

    logger.info("Logging configured. File: %s", log_file)
    return logger
