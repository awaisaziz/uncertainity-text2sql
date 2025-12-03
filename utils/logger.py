"""Central logging utilities."""
from __future__ import annotations

import json
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, Optional

from config import settings

LOG_PATH = Path(settings.default_output_dir) / "run.log"
LOG_PATH.parent.mkdir(parents=True, exist_ok=True)


class Logger:
    """Simple JSONL logger for tracing prompts and outputs."""

    def __init__(self, log_file: Path) -> None:
        self.log_file = log_file

    def _write(self, level: str, message: str, extra: Optional[Dict[str, Any]] = None) -> None:
        record = {
            "timestamp": datetime.utcnow().isoformat(),
            "level": level,
            "message": message,
        }
        if extra:
            record.update(extra)
        with self.log_file.open("a", encoding="utf-8") as f:
            f.write(json.dumps(record, ensure_ascii=False) + "\n")

    def log_prompt(self, provider: str, model: str, prompt: str) -> None:
        self._write(
            "PROMPT",
            "Logged LLM prompt.",
            extra={"provider": provider, "model": model, "prompt": prompt},
        )

    def log_llm_output(self, provider: str, model: str, raw_output: Any) -> None:
        self._write(
            "LLM_OUTPUT",
            "Logged LLM raw output.",
            extra={"provider": provider, "model": model, "raw_output": raw_output},
        )

    def log_info(self, message: str, extra: Optional[Dict[str, Any]] = None) -> None:
        self._write("INFO", message, extra)

    def log_llm_prompt(self, provider: str, model: str, prompt: str) -> None:
        self.log_prompt(provider, model, prompt)


_logger_instance: Logger | None = None


def get_logger() -> Logger:
    global _logger_instance
    if _logger_instance is None:
        _logger_instance = Logger(LOG_PATH)
    return _logger_instance


__all__ = ["get_logger", "Logger"]
