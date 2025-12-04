"""DeepSeek chat client using the official OpenAI-compatible API."""
from __future__ import annotations

import os
from dataclasses import dataclass
from typing import List, Tuple

from openai import OpenAI
from openai.types.chat import ChatCompletion
from dotenv import load_dotenv

# Load .env variables once at module import
load_dotenv()

@dataclass
class DeepSeekSQLResult:
    """Structured result for a single SQL generation."""

    sql_text: str

SYSTEM_PROMPT = """
You are an expert Text-to-SQL generator. Use the provided database schema to produce a correct SQL query that answers the question. 
Do not use table aliases. Return only the SQL query.
""".strip()

class DeepSeekChatLLM:
    """Wrapper around the DeepSeek ChatCompletions endpoint."""

    def __init__(self, *, api_key: str | None = None, max_tokens: int = 2048, temperature: float = 1.0) -> None:
        self.api_key = api_key or os.getenv("DEEPSEEK_API_KEY")
        if not self.api_key:
            raise EnvironmentError("DEEPSEEK_API_KEY environment variable is required for DeepSeek access.")

        # DeepSeek provides an OpenAI-compatible API hosted at this base URL.
        self.client = OpenAI(api_key=self.api_key, base_url="https://api.deepseek.com")
        self.max_tokens = max_tokens
        self.temperature = temperature

    def generate_sql(self, prompt: str) -> Tuple[str, List[float], float]:
        """Generate SQL for a given prompt and return text plus logprob details."""

        resp: ChatCompletion = self.client.chat.completions.create(
            model="deepseek-chat",
            
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": prompt}
            ],
            max_tokens=self.max_tokens,
            temperature=self.temperature,
        )
        
        sql_text = self._extract_text(resp)
        return sql_text

    @staticmethod
    def _extract_text(completion: ChatCompletion) -> str:
        """Extract the textual content from the chat completion."""

        message = completion.choices[0].message
        content = message.content or ""
        if isinstance(content, str):
            return content.strip()

        text_parts = []
        for part in content:
            if getattr(part, "type", None) == "text":
                text = getattr(part, "text", "")
                if text:
                    text_parts.append(text)
        return "".join(text_parts).strip()
