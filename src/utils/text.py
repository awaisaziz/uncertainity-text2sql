import re
from typing import Optional


SQL_FENCE_PATTERN = re.compile(r"```sql\s*(.*?)```", re.IGNORECASE | re.DOTALL)


def clean_sql_text(text: str) -> str:
    """Extract the SQL statement from model output."""
    fenced = SQL_FENCE_PATTERN.search(text)
    candidate = fenced.group(1) if fenced else text

    # Remove code fences or surrounding quotes
    candidate = candidate.strip().strip("`\"'")

    # If multiple statements, keep the first one.
    if ";" in candidate:
        candidate = candidate.split(";", 1)[0] + ";"

    # Collapse whitespace to a single space for storage
    candidate = re.sub(r"\s+", " ", candidate).strip()
    return candidate
