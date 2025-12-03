from dataclasses import dataclass
from typing import Dict

from .base import LLMProvider, LLMResponse
from .openai_client import OpenAIChatLLM


@dataclass
class OpenRouterProvider(LLMProvider):
    name: str = "openrouter"

    def __post_init__(self) -> None:
        self._client = OpenAIChatLLM(router=self.name)

    def generate_sql(
        self, prompt: Dict[str, str], model: str, max_tokens: int, metadata: Dict[str, str] | None = None
    ) -> LLMResponse:
        _ = metadata
        return self._client.generate(
            system_prompt=prompt["system"], user_prompt=prompt["user"], model=model, max_tokens=max_tokens
        )
