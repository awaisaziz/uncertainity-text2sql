"""Prompt templates for Text-to-SQL models."""
from __future__ import annotations

from dataclasses import dataclass
from textwrap import dedent


ZERO_SHOT_TEMPLATE = dedent(
    """
    You are an expert SQL query developer.
    Given the following database schema:
    {schema}
    Write a correct SQL query to answer this question:
    Q: {question}
    Only output the SQL query.
    Number of queries to return: {num_query}
    """
).strip()


@dataclass
class ZeroShotPromptBuilder:
    system_prompt: str = (
        "You are a precise Text-to-SQL assistant. Generate SQL queries that strictly match the provided schema. "
        "Return only SQL code without explanation."
    )

    def build(self, question: str, schema: str, db_id: str | None, num_query: int = 1) -> dict:
        """Return the zero-shot prompt for ``question`` and ``schema``."""

        del db_id  # kept for compatibility if we want to extend the prompt later
        user_prompt = ZERO_SHOT_TEMPLATE.format(
            question=question.strip(), schema=schema.strip(), num_query=num_query
        )
        return {"system": self.system_prompt, "user": user_prompt}
