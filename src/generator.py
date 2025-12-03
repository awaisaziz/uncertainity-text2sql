import json
import time
from pathlib import Path
from typing import Dict, Iterable, List

from tqdm import tqdm  # Added tqdm for progress bar

from src.prompts.zero_shot import ZeroShotPromptBuilder
from src.providers.base import LLMProvider, LLMResponse
from src.utils.text import clean_sql_text


class PredictionGenerator:
    def __init__(
        self,
        provider: LLMProvider,
        prompt_builder: ZeroShotPromptBuilder,
        model: str,
        num_query: int,
        max_tokens: int,
        delay: float,
        logger,
        num_sample: int = 1,  # Added parameter for limiting sample size
    ):
        self.provider = provider
        self.prompt_builder = prompt_builder
        self.model = model
        self.num_query = num_query
        self.max_tokens = max_tokens
        self.delay = delay
        self.logger = logger
        self.num_sample = num_sample

    def generate(self, records: Iterable[Dict], output_file: Path) -> None:
        output_file.parent.mkdir(parents=True, exist_ok=True)
        results: List[Dict] = []

        # Convert to list to allow slicing
        records = list(records)[:self.num_sample]

        # Wrap with tqdm for progress visualization
        for record in tqdm(records, desc="Generating SQL Predictions", unit="record"):
            prompt = self.prompt_builder.build(
                question=record["question"],
                schema=record["schema"],
                db_id=record["db_id"],
                num_query=self.num_query,
            )

            self.logger.info("Sending prompt for question %s to %s", record.get("q_id"), self.provider.name)

            response: LLMResponse = self.provider.generate_sql(
                prompt=prompt,
                model=self.model,
                max_tokens=self.max_tokens,
                metadata={"db_id": record["db_id"]},
            )

            clean_sql = clean_sql_text(response.sql)
            result_entry = {
                "question_id": record.get("q_id"),
                "db_id": record["db_id"],
                "question": record["question"],
                "schema": record["schema"],
                "sql": clean_sql,
                "logit_prob": response.logit_prob,
            }

            results.append(result_entry)
            self.logger.info("Received SQL for %s: %s", record.get("q_id"), clean_sql)
            time.sleep(self.delay)

        # Write results to JSON file
        with output_file.open("w", encoding="utf-8") as f:
            json.dump(results, f, indent=2)

        self.logger.info("Stored predictions at %s", output_file)
