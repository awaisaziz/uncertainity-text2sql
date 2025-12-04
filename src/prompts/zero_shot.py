"""Zero-shot prompt builder for Text-to-SQL."""
from __future__ import annotations

from textwrap import dedent

ZERO_SHOT_TEMPLATE = dedent(
    """
    You are an expert SQL query developer.
    Given the following database schema:
    {schema}
    Write a correct SQL query to answer this question:
    Q: {question}
    Return only the SQL query.
    """
).strip()


def build_zero_shot_prompt(question: str, schema: str) -> str:
    """Return a zero-shot prompt for the provided question and schema."""

    return ZERO_SHOT_TEMPLATE.format(question=question.strip(), schema=schema.strip())
