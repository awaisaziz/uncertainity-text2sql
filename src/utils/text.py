import re
import json
from typing import Any, List


FENCE_PATTERN = re.compile(r"```sql\s*(.*?)```", re.IGNORECASE | re.DOTALL)

# Matches any JSON array in the text
JSON_ARRAY_PATTERN = re.compile(
    r"\[\s*{.*?}\s*\]",
    re.DOTALL
)

def clean_json_array(text: str) -> List[Any]:
    """Return a parsed JSON array from messy LLM output.

    This helper is intentionally defensive: instead of raising, it returns an
    empty list when parsing fails. It normalises common formats such as fenced
    markdown blocks, ``json [ ... ]`` prefixes, or loose arrays embedded in
    prose.
    """
    if not text:
        return []

    raw = text.strip()

    # 1. Try extracting from fenced markdown blocks
    fenced = FENCE_PATTERN.search(raw)
    if fenced:
        raw = fenced.group(1).strip()

    # 2. Remove leading 'json', 'JSON'
    raw = re.sub(r"(?i)\bjson\b", "", raw).strip()

    # 3. Find the first JSON array in the text
    array_match = JSON_ARRAY_PATTERN.search(raw)
    if array_match:
        json_str = array_match.group(0).strip()
    else:
        # Fallback: try taking text between first '[' and last ']'
        start = raw.find("[")
        end = raw.rfind("]")
        if start == -1 or end == -1:
            return []
        json_str = raw[start : end + 1].strip()

    # 4. Attempt to parse the JSON with a couple of lenient passes
    for candidate in (json_str, json_str.replace("'", '"')):
        try:
            parsed = json.loads(candidate)
            if isinstance(parsed, list):
                return parsed
            return [parsed]  # If it's a dict or scalar, wrap it
        except json.JSONDecodeError:
            continue

    return []

def clean_sql_text(text: str) -> str:
    """Extract the SQL statement from model output."""
    fenced = FENCE_PATTERN.search(text)
    candidate = fenced.group(1) if fenced else text

    # Remove code fences or surrounding quotes
    candidate = candidate.strip().strip("`\"'")

    # If multiple statements, keep the first one.
    if ";" in candidate:
        candidate = candidate.split(";", 1)[0] + ";"

    # Collapse whitespace to a single space for storage
    candidate = re.sub(r"\s+", " ", candidate).strip()
    return candidate
