"""Configuration package for text-to-SQL scaffold."""
from .settings import settings
from .defaults import (
    get_default_provider,
    get_default_model,
    get_default_max_tokens,
    get_default_dataset_path,
    get_default_output_dir,
    get_default_num_samples,
    get_default_technique,
)

__all__ = [
    "settings",
    "get_default_provider",
    "get_default_model",
    "get_default_max_tokens",
    "get_default_dataset_path",
    "get_default_output_dir",
    "get_default_num_samples",
    "get_default_technique",
]
