"""OpenAI ChatGPT client using the official API."""
from __future__ import annotations

import os

from openai import OpenAI

from src.llm.base import SYSTEM_PROMPT, extract_text


class OpenAIChatLLM:
    """Wrapper around OpenAI ChatCompletions endpoint."""

    def __init__(
        self,
        *,
        model: str = "gpt-4o-mini",
        api_key: str | None = None,
        max_tokens: int = 2048,
        temperature: float = 1.0,
    ) -> None:
        self.provider = "openai"
        self.model = model
        self.api_key = api_key or os.getenv("OPENAI_API_KEY")
        if not self.api_key:
            raise EnvironmentError("OPENAI_API_KEY environment variable is required for OpenAI access.")

        self.client = OpenAI(api_key=self.api_key)
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
            # Newer OpenAI models require `max_completion_tokens` instead of `max_tokens`.
            max_completion_tokens=self.max_tokens,
            temperature=self.temperature,
        )

        sql_text = extract_text(resp)
        return sql_text


__all__ = ["OpenAIChatLLM"]
