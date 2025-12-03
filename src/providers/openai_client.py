"""Client wrappers for calling OpenRouter and DeepSeek models."""
from __future__ import annotations

import logging
import os
from dataclasses import dataclass
from typing import Dict, Optional

from openai import OpenAI, OpenAIError
from openai.types.chat import ChatCompletion
from dotenv import load_dotenv

from .base import LLMResponse

LOGGER = logging.getLogger(__name__)

# Load .env variables before reading API keys
load_dotenv()

class LLMError(RuntimeError):
    """Raised when the language model API call fails."""

@dataclass
class RouterConfig:
    """Configuration required to initialise an OpenAI compatible router."""

    base_url: str
    api_key_env: str
    default_headers: Optional[Dict[str, str]] = None


ROUTER_CONFIGS: Dict[str, RouterConfig] = {
    "openrouter": RouterConfig(
        base_url="https://openrouter.ai/api/v1",
        api_key_env="OPENROUTER_API_KEY",
    ),
    "deepseek": RouterConfig(
        base_url="https://api.deepseek.com/v1",
        api_key_env="DEEPSEEK_API_KEY",
    ),
}


class OpenAIChatLLM:
    """Wrapper around OpenAI compatible chat completion endpoints."""

    def __init__(self, router: str, api_key: Optional[str] = None, timeout: int = 120) -> None:
        try:
            router_config = ROUTER_CONFIGS[router]
        except KeyError as exc:  # pragma: no cover - defensive programming
            raise ValueError(
                f"Unsupported router '{router}'. Supported routers: {', '.join(sorted(ROUTER_CONFIGS))}."
            ) from exc

        resolved_api_key = api_key or os.getenv(router_config.api_key_env)
        if not resolved_api_key:
            raise EnvironmentError(
                f"{router_config.api_key_env} environment variable is required to call the {router} API."
            )

        LOGGER.debug("Initialising OpenAI client for router '%s'", router)

        client = OpenAI(
            api_key=resolved_api_key,
            base_url=router_config.base_url,
            default_headers=router_config.default_headers,
        )
        self.client = client.with_options(timeout=timeout)
        self.router = router

    def generate(self, *, system_prompt: str, user_prompt: str, model: str, max_tokens: int) -> LLMResponse:
        """Call the configured router to generate SQL for ``user_prompt`` using ``model``."""

        LOGGER.debug("Calling router '%s' with model %s", self.router, model)
        LOGGER.debug("System prompt: %s", system_prompt)
        LOGGER.debug("User prompt: %s", user_prompt)

        try:
            completion: ChatCompletion = self.client.chat.completions.create(
                model=model,
                temperature=0,
                max_tokens=max_tokens,
                logprobs=True,
                top_logprobs=5,
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_prompt},
                ],
            )
        except OpenAIError as exc:  # pragma: no cover - network dependent
            LOGGER.exception("%s request failed: %s", self.router, exc)
            raise LLMError(f"{self.router} request failed") from exc

        sql = self._extract_sql(completion)
        logprob = self._extract_logprob(completion)
        LOGGER.debug("Received SQL: %s", sql)
        return LLMResponse(sql=sql, logit_prob=logprob)

    @staticmethod
    def _extract_sql(completion: ChatCompletion) -> str:
        if not completion.choices:
            raise LLMError("No choices returned from completion response.")

        message = completion.choices[0].message
        content = message.content
        if not content:
            raise LLMError("No content in completion response.")

        if isinstance(content, str):
            text_content = content
        else:
            text_parts = [
                getattr(part, "text", "")
                for part in content
                if getattr(part, "type", None) == "text" and getattr(part, "text", "")
            ]
            if not text_parts:
                raise LLMError("Completion content did not contain text parts.")
            text_content = "".join(text_parts)

        return text_content.strip()

    @staticmethod
    def _extract_logprob(completion: ChatCompletion) -> float:
        if not completion.choices:
            return 0.0

        logprobs = completion.choices[0].logprobs
        if not logprobs or not logprobs.content:
            return 0.0

        token_logprobs = [item.logprob for item in logprobs.content if item.logprob is not None]
        if not token_logprobs:
            return 0.0
        return float(sum(token_logprobs))


def safe_generate(
    *,
    system_prompt: str,
    user_prompt: str,
    model: str,
    max_tokens: int,
    router: str = "openrouter",
    api_key: Optional[str] = None,
) -> LLMResponse:
    """Convenience function that wraps :class:`OpenAIChatLLM` with logging."""

    client = OpenAIChatLLM(router=router, api_key=api_key)
    return client.generate(system_prompt=system_prompt, user_prompt=user_prompt, model=model, max_tokens=max_tokens)
