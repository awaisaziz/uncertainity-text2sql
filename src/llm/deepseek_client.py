"""DeepSeek chat client using the official OpenAI-compatible API."""
from __future__ import annotations

import os

from openai import OpenAI
from openai.types.chat import ChatCompletion
from dotenv import load_dotenv

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
6. All queries must return IDENTICAL logical results (same data, same column names)
7. Output ONLY the JSON array - no explanations, no additional text

Example of correct output when n=2:
[{"sql": "SELECT count(*) FROM continents"}, {"sql": "SELECT count(DISTINCT continent) FROM countries"}]""".strip()

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

    def generate_sql(self, prompt: str) -> str:
        """Generate SQL for a given prompt."""

        resp: ChatCompletion = self.client.chat.completions.create(
            model="deepseek-chat",

            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": prompt}
            ],
            max_tokens=self.max_tokens,
            temperature=self.temperature,
        )

        sql_text = self.extract_text(resp)
        return sql_text

    @staticmethod
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
