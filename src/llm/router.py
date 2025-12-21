"""LLM router that selects the correct provider implementation."""
from __future__ import annotations

from typing import Protocol

from src.llm.providers.deepseek_client import DeepSeekChatLLM
from src.llm.providers.grok_client import GrokChatLLM
from src.llm.providers.openai_client import OpenAIChatLLM


class SQLGenerator(Protocol):
    """Protocol for SQL generator models."""

    provider: str
    model: str

    def generate_sql(self, prompt: str) -> str:  # pragma: no cover - thin wrapper
        ...


def create_llm(provider: str, model: str, *, max_tokens: int, temperature: float = 1.0) -> SQLGenerator:
    """Instantiate the requested LLM provider."""

    provider_normalized = provider.lower()
    if provider_normalized == "deepseek":
        return DeepSeekChatLLM(model=model, max_tokens=max_tokens, temperature=temperature)
    if provider_normalized == "grok":
        return GrokChatLLM(model=model, max_tokens=max_tokens, temperature=temperature)
    if provider_normalized == "openai":
        return OpenAIChatLLM(model=model, max_tokens=max_tokens, temperature=temperature)

    raise ValueError(f"Unsupported provider '{provider}'. Choose from: deepseek, grok, openai.")


__all__ = ["SQLGenerator", "create_llm"]
