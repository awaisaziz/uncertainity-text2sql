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
from src.utils.clean_text import clean_json_array

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

            # ---- Generate SQL using LLM ----
            prompt = build_multi_sql_prompt(
                record["question"], record["schema"], self.num_query
            )
            self.logger.info("Generating SQL using user prompt: %s", prompt)

            try:
                sql_text = self.llm.generate_sql(prompt)
            except Exception as exc:  # defensive around external calls
                self.logger.exception("LLM generation failed: %s", exc)
                sql_text = ""
            self.logger.info("Raw LLM response: %s", sql_text)

            # ---- Extract structured candidates safely ----
            try:
                parsed_candidates = clean_json_array(sql_text)
                self.logger.info("Parsed candidates: %s", parsed_candidates)
            except Exception as e:
                self.logger.error("JSON parsing failed: %s", str(e))
                parsed_candidates = []

            # ---- Build output entry ----
            generated_entries.append(
                {
                    "id": idx,
                    "question": record["question"],
                    "db_id": record["db_id"],
                    "candidates": parsed_candidates,
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
