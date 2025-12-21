"""Grok (xAI) chat client using OpenAI-compatible API."""
from __future__ import annotations

import os

from openai import OpenAI

from src.llm.base import SYSTEM_PROMPT, extract_text


class GrokChatLLM:
    """Wrapper around the Grok ChatCompletions endpoint."""

    def __init__(
        self,
        *,
        model: str = "grok-2-latest",
        api_key: str | None = None,
        max_tokens: int = 2048,
        temperature: float = 1.0,
    ) -> None:
        self.provider = "grok"
        self.model = model
        self.api_key = api_key or os.getenv("GROK_API_KEY")
        if not self.api_key:
            raise EnvironmentError("GROK_API_KEY environment variable is required for Grok access.")

        # Grok provides an OpenAI-compatible API hosted at this base URL.
        self.client = OpenAI(api_key=self.api_key, base_url="https://api.x.ai")
        self.max_tokens = max_tokens
        self.temperature = temperature

    def generate_sql(self, prompt: str) -> str:
        """Generate SQL for a given prompt."""

        resp = self.client.chat.completions.create(
            model=self.model,
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": prompt},
            ],
            max_tokens=self.max_tokens,
            temperature=self.temperature,
        )

        sql_text = extract_text(resp)
        return sql_text


__all__ = ["GrokChatLLM"]
