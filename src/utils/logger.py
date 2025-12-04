import logging
from logging.handlers import RotatingFileHandler
from pathlib import Path

LOG_FORMAT = "%(asctime)s - %(levelname)s:%(name)s:%(message)s"

def get_logger(log_dir: Path, log_name: str = "app.log", level: int = logging.INFO) -> logging.Logger:
    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / log_name

    logger = logging.getLogger("text2sql")
    logger.setLevel(level)

    # Rotate logs automatically (e.g., keep last 5, max 10MB each)
    file_handler = RotatingFileHandler(log_file, maxBytes=10_000_000, backupCount=5)
    file_handler.setFormatter(logging.Formatter(LOG_FORMAT))
    logger.addHandler(file_handler)

    if not any(isinstance(handler, logging.StreamHandler) for handler in logger.handlers):
        stream_handler = logging.StreamHandler()
        stream_handler.setFormatter(logging.Formatter(LOG_FORMAT))
        logger.addHandler(stream_handler)

    logger.info("Logging configured. File: %s", log_file)
    return logger
