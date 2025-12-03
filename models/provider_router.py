"""Router for provider clients."""
from __future__ import annotations

from typing import Dict, Type

from .deepseek_client import DeepSeekClient
from .gemini_client import GeminiClient

_PROVIDER_MAP: Dict[str, Type] = {
    "deepseek": DeepSeekClient,
    "gemini": GeminiClient,
}


def get_provider(provider_name: str):
    key = provider_name.lower()
    if key not in _PROVIDER_MAP:
        raise ValueError(f"Unsupported provider: {provider_name}")
    return _PROVIDER_MAP[key]()


__all__ = ["get_provider"]
