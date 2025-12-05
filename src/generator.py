"""SQL generation pipeline using the DeepSeek chat model."""
from __future__ import annotations

import json
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List

from dotenv import load_dotenv
from tqdm import tqdm

from src.llm.deepseek_client import DeepSeekChatLLM
from src.prompts.zero_shot import build_zero_shot_prompt
from src.utils.text import clean_sql_text

# Load environment variables for API keys.
load_dotenv()


@dataclass
class Candidate:
    sql: str


class PredictionGenerator:
    """Generate SQL predictions for a list of Spider questions."""

    def __init__(
        self,
        llm: DeepSeekChatLLM,
        *,
        num_query: int,
        max_tokens: int,
        delay: float,
        num_sample: int,
        logger,
    ) -> None:
        self.llm = llm
        self.num_query = num_query
        self.max_tokens = max_tokens
        self.delay = delay
        self.num_sample = num_sample
        self.logger = logger

    def generate(self, records: Iterable[Dict], output_file: Path, config: Dict) -> None:
        """Generate SQL predictions and write them to ``output_file``."""

        output_file.parent.mkdir(parents=True, exist_ok=True)
        records = list(records)[: self.num_sample]

        generated_entries: List[Dict] = []
        for idx, record in enumerate(tqdm(records, desc="Generating SQL", unit="question")):
            # self.logger.info("Processing question %s: %s", record.get("q_id", idx), record["question"])
            # self.logger.info("Schema for %s:\n%s", record["db_id"], record["schema"])
            
            prompt = build_zero_shot_prompt(record["question"], record["schema"])
            candidates: List[Candidate] = []
            self.logger.info("Generating SQL using user prompt: %s", prompt)

            for _ in range(self.num_query):
                sql_text = self.llm.generate_sql(prompt)
                cleaned_sql = clean_sql_text(sql_text)
                candidates.append(Candidate(sql=cleaned_sql))
                self.logger.info("Generated SQL: %s", cleaned_sql)

                if self.delay > 0.0:
                    time.sleep(self.delay)

            all_sql = [candidate.sql for candidate in candidates]
            self.logger.info("All candidates for question %s: %s", record.get("q_id", idx), all_sql)

            generated_entries.append(
                {
                    "id": idx,
                    "question": record["question"],
                    "db_id": record["db_id"],
                    "candidates": [
                        {
                            "sql": candidate.sql
                        }
                        for candidate in candidates
                    ],
                }
            )

        output_payload = {
            "dataset_path": str(Path(config["dataset_path"])),
            "default_provider": "deepseek",
            "default_model": "deepseek-chat",
            "mode": "generate",
            "num_sample": self.num_sample,
            "num_query": self.num_query,
            "max_tokens": self.max_tokens,
            "generated": generated_entries,
        }

        with output_file.open("w", encoding="utf-8") as f:
            json.dump(output_payload, f, indent=2)

        self.logger.info("Stored predictions at %s", output_file)
