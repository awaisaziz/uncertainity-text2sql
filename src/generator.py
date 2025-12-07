"""SQL generation pipeline using the DeepSeek chat model."""

import json
from dataclasses import dataclass
from pathlib import Path
import time
from typing import Dict, Iterable, List

from dotenv import load_dotenv
from tqdm import tqdm

from src.llm.deepseek_client import DeepSeekChatLLM
from src.prompts.zero_shot import build_multi_sql_prompt
from src.utils.text import clean_sql_text, clean_json_array

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

            if self.delay > 0:
                time.sleep(self.delay)

            # self.logger.info("Processing question %s: %s", record.get("q_id", idx), record["question"])
            # self.logger.info("Schema for %s:\n%s", record["db_id"], record["schema"])
            
            prompt = build_multi_sql_prompt(
                record["question"], record["schema"], self.num_query
            )
            self.logger.info("Generating SQL using user prompt: %s", prompt)

            try:
                sql_text = self.llm.generate_sql(prompt)
            except Exception as exc:  # noqa: BLE001 - defensive around external calls
                self.logger.exception("LLM generation failed: %s", exc)
                sql_text = ""
            self.logger.info("Raw LLM response: %s", sql_text)

            # ---- Extract structured candidates safely ----
            parsed_candidates = clean_json_array(sql_text)

            # ---- Normalize each candidate to ensure `{"sql": "<query>"}` format ----
            candidates = []
            for item in parsed_candidates[: self.num_query]:
                if isinstance(item, dict) and "sql" in item:
                    sql_value = clean_sql_text(item["sql"])
                else:
                    sql_value = clean_sql_text(str(item))

                if sql_value:
                    candidates.append(Candidate(sql=sql_value))

            if not candidates:
                fallback_sql = clean_sql_text(sql_text or "SELECT 1;") or "SELECT 1;"
                candidates.append(Candidate(sql=fallback_sql))

            # Ensure we always have `num_query` candidates to keep the output structure stable
            while len(candidates) < self.num_query:
                candidates.append(Candidate(sql=candidates[-1].sql))

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
