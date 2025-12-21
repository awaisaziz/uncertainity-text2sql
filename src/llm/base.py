"""Common helpers and prompts for LLM providers."""

from __future__ import annotations

from dotenv import load_dotenv
from openai.types.chat import ChatCompletion

# Load .env variables once at module import
load_dotenv()

SYSTEM_PROMPT = """You are an expert SQL query generator. You generate multiple semantically correct SQL query variations for the same question.

IMPORTANT RULES YOU MUST FOLLOW:
1. You ALWAYS return ONLY a valid JSON array in this exact format: [{"sql": "full SQL query here"}]
2. You generate EXACTLY the number of queries requested (n value from user)
3. Each SQL query must use a DISTINCT approach (different tables, joins, subqueries, aggregation methods)
4. Only use "AS" for table aliases when joining tables or when column names would be ambiguous
   - ALLOWED: "SELECT T2.Year ,  T1.Official_Name FROM city AS T1 JOIN farm_competition AS T2 ON T1.City_ID  =  T2.Host_city_ID"
   - ALLOWED: "SELECT avg(T1.product_price) FROM Products AS T1 JOIN Order_items AS T2 ON T1.product_id  =  T2.product_id"
   - PROHIBITED: "SELECT avg(product_price) AS average_price FROM Products"
   - PROHIBITED: "SELECT count(*) AS club_count FROM club"
5. NEVER add column aliases - preserve original column names from the schema
6. All queries must return IDENTICAL logical results
7. Output ONLY the JSON array - no explanations, no additional text

Example of correct output when n=2:
[{"sql": "SELECT count(*) FROM Authors"}, {"sql": "SELECT other_details FROM Authors WHERE author_name  =  'Addison Denesik'"}]""".strip()


def extract_text(completion: ChatCompletion) -> str:
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


__all__ = ["SYSTEM_PROMPT", "extract_text"]
