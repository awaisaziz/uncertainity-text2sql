"""Load environment variables and base configuration."""
from __future__ import annotations

import json
import os
from dataclasses import dataclass
from pathlib import Path

from dotenv import load_dotenv


@dataclass
class Settings:
    """Container for application settings."""

    default_provider: str
    default_model: str
    default_max_tokens: int
    default_dataset_path: str
    default_output_dir: str
    default_num_samples: int
    default_technique: str
    deepseek_api_key: str | None = None
    gemini_api_key: str | None = None
    openai_base_url: str | None = None



def _load_base_config() -> dict:
    config_path = Path(__file__).with_name("config.json")
    with config_path.open("r", encoding="utf-8") as f:
        return json.load(f)


def load_settings() -> Settings:
    load_dotenv()
    base_config = _load_base_config()

    return Settings(
        default_provider=base_config.get("default_provider", "deepseek"),
        default_model=base_config.get("default_model", "deepseek-chat"),
        default_max_tokens=int(base_config.get("default_max_tokens", 2048)),
        default_dataset_path=base_config.get("default_dataset_path", "data/dev.json"),
        default_output_dir=base_config.get("default_output_dir", "outputs/"),
        default_num_samples=int(base_config.get("default_num_samples", 100)),
        default_technique=base_config.get("default_technique", "zeroshot"),
        deepseek_api_key=os.getenv("DEEPSEEK_API_KEY"),
        gemini_api_key=os.getenv("GEMINI_API_KEY"),
        openai_base_url=os.getenv(
            "OPENAI_BASE_URL",
            "https://generativelanguage.googleapis.com/v1beta/openai/",
        ),
    )


settings = load_settings()

__all__ = ["Settings", "settings", "load_settings"]
