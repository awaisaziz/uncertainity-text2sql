"""Prompt builder for requesting multiple Text-to-SQL candidates."""
from __future__ import annotations

from textwrap import dedent

MULTI_SQL_TEMPLATE = dedent(
"""Given this database schema:
{schema}

Question: {question}

Generate exactly {n} different, correct SQL queries that answer the question.
Each query must use a different SQL approach. Return ONLY a JSON array with {n} objects.

Format: [{{"sql": "query1"}}, {{"sql": "query2"}}, ...]"""
).strip()


def build_multi_sql_prompt(question: str, schema: str, num_queries: int) -> str:
    """Return a multi-candidate prompt for the provided question and schema."""

    return MULTI_SQL_TEMPLATE.format(
        question=question.strip(), schema=schema.strip(), n=num_queries
    )
