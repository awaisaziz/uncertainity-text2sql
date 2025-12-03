"""DeepSeek provider client wrapper."""
from __future__ import annotations

from typing import Any, Dict

from openai import OpenAI

from config import settings
from utils.logger import get_logger

logger = get_logger()


class DeepSeekClient:
    """Client for interacting with DeepSeek's OpenAI-compatible API."""

    def __init__(self) -> None:
        self.client = OpenAI(
            api_key=settings.deepseek_api_key,
            base_url="https://api.deepseek.com",
        )
        self.provider_name = "deepseek"

    def generate_sql(
        self, question: str, schema: str | dict, model: str, max_tokens: int
    ) -> Dict[str, Any]:
        prompt = f"Question: {question}\nSchema: {schema}\nGenerate SQL:"
        logger.log_llm_prompt(self.provider_name, model, prompt)

        # Placeholder response structure; replace with real API call.
        simulated_sql = f"-- DeepSeek SQL for: {question}"
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


__all__ = ["DeepSeekClient"]
