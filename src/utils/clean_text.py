import re
import json
from typing import Any, List

# match ```json ... ``` OR ```sql ... ```
FENCE_PATTERN = re.compile(r"```(?:json|sql)?\s*(.*?)```", re.IGNORECASE | re.DOTALL)

# match any JSON array containing objects
JSON_ARRAY_PATTERN = re.compile(r"\[\s*{.*?}\s*\]", re.DOTALL)


def clean_json_array(text: str) -> List[Any]:
    """
    Extract a JSON array of SQL candidates from messy LLM output.
    Returns a list of dicts: [{"sql": "..."} ...]
    """

    if not text:
        return []

    raw = text.strip()

    # 1. Extract fenced code block first if present
    fenced = FENCE_PATTERN.search(raw)
    if fenced:
        raw = fenced.group(1).strip()

    # 2. Remove leading 'json' literal if present
    raw = re.sub(r"(?i)\bjson\b", "", raw).strip()

    # 3. Try a strict JSON array match
    array_match = JSON_ARRAY_PATTERN.search(raw)
    if array_match:
        json_str = array_match.group(0).strip()
    else:
        # Fallback: take everything between the first [ and last ]
        start = raw.find("[")
        end = raw.rfind("]")
        if start == -1 or end == -1:
            return []
        json_str = raw[start:end+1].strip()

    # 4. Try parsing safely
    candidates = [
        json_str,
        json_str.replace("'", '"'),  # fallback: fix single quotes
    ]

    for c in candidates:
        try:
            parsed = json.loads(c)
            if isinstance(parsed, list):
                return parsed
            return [parsed]
        except json.JSONDecodeError:
            continue

    return []
