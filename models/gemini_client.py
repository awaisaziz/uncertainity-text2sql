"""Gemini provider client wrapper."""
from __future__ import annotations

from typing import Any, Dict

from openai import OpenAI

from config import settings
from utils.logger import get_logger

logger = get_logger()


class GeminiClient:
    """Client for interacting with Gemini via OpenAI-compatible API."""

    def __init__(self) -> None:
        self.client = OpenAI(
            api_key=settings.gemini_api_key,
            base_url=settings.openai_base_url,
        )
        self.provider_name = "gemini"

    def generate_sql(
        self, question: str, schema: str | dict, model: str, max_tokens: int
    ) -> Dict[str, Any]:
        prompt = f"Question: {question}\nSchema: {schema}\nGenerate SQL:"
        logger.log_llm_prompt(self.provider_name, model, prompt)

        # Placeholder response structure; replace with real API call.
        simulated_sql = f"-- Gemini SQL for: {question}"
        raw_response: Dict[str, Any] = {
            "choices": [
                {
                    "message": {
                        "content": simulated_sql,
                    },
                    "finish_reason": "stop",
                }
            ]
        }
        logger.log_llm_output(self.provider_name, model, raw_response)

        return {"sql": simulated_sql, "provider": self.provider_name, "raw_response": raw_response}


__all__ = ["GeminiClient"]
