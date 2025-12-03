"""Convenience accessors for configuration defaults."""
from __future__ import annotations

from .settings import settings


def get_default_provider() -> str:
    return settings.default_provider


def get_default_model() -> str:
    return settings.default_model


def get_default_max_tokens() -> int:
    return settings.default_max_tokens


def get_default_dataset_path() -> str:
    return settings.default_dataset_path


def get_default_output_dir() -> str:
    return settings.default_output_dir


def get_default_num_samples() -> int:
    return settings.default_num_samples


def get_default_technique() -> str:
    return settings.default_technique


__all__ = [
    "get_default_provider",
    "get_default_model",
    "get_default_max_tokens",
    "get_default_dataset_path",
    "get_default_output_dir",
    "get_default_num_samples",
    "get_default_technique",
]
