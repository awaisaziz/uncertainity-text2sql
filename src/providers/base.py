from dataclasses import dataclass
from typing import Dict, Protocol


@dataclass
class LLMResponse:
    sql: str
    logit_prob: float


class LLMProvider(Protocol):
    name: str

    def generate_sql(
        self, prompt: Dict[str, str], model: str, max_tokens: int, metadata: Dict[str, str] | None = None
    ) -> LLMResponse:
        ...
