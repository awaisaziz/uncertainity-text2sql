"""Command-line interface for running text-to-SQL generation."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Optional

import click

from config import defaults
from config import settings
from generation import generate_sql_query
from models import get_provider
from sac import rerank_sql_candidates, TripletEmbeddingModel
from utils import load_spider_dataset, get_logger

logger = get_logger()


@click.command()
@click.option("--dataset", default=defaults.get_default_dataset_path(), show_default=True)
@click.option("--provider", default=defaults.get_default_provider(), show_default=True)
@click.option("--model", default=defaults.get_default_model(), show_default=True)
@click.option("--output", default=str(Path(defaults.get_default_output_dir()) / "run.json"), show_default=True)
@click.option("--technique", default=defaults.get_default_technique(), show_default=True)
@click.option("--num_samples", default=defaults.get_default_num_samples(), show_default=True, type=int)
@click.option("--max_tokens", default=defaults.get_default_max_tokens(), show_default=True, type=int)
def main(
    dataset: str,
    provider: str,
    model: str,
    output: str,
    technique: str,
    num_samples: int,
    max_tokens: int,
) -> None:
    """Run text-to-SQL generation for a dataset slice."""
    logger.log_info(
        "CLI invocation started.",
        extra={
            "dataset": dataset,
            "provider": provider,
            "model": model,
            "output": output,
            "technique": technique,
            "num_samples": num_samples,
            "max_tokens": max_tokens,
        },
    )

    data = load_spider_dataset(dataset)
    subset = data[:num_samples]

    provider_client = get_provider(provider)
    results = []
    triplet_model: Optional[TripletEmbeddingModel] = None
    if "triplet" in technique:
        triplet_model = TripletEmbeddingModel()

    for item in subset:
        question = item.get("question") or item.get("utterance") or ""
        schema = item.get("schema") or item.get("schema_name") or "{}"

        result = generate_sql_query(
            question=question,
            schema=schema,
            provider_client=provider_client,
            model=model,
            max_tokens=max_tokens,
        )

        if "sac" in technique:
            reranked = rerank_sql_candidates([result["sql"]])
            result["sql"] = reranked[0] if reranked else result["sql"]

        if triplet_model is not None:
            embedding = triplet_model.encode(question)
            result["embedding"] = embedding

        result_record = {
            "question": question,
            "schema": schema,
            "sql": result.get("sql"),
            "provider": result.get("provider"),
            "raw_response": result.get("raw_response"),
        }
        if "embedding" in result:
            result_record["embedding"] = result["embedding"]
        results.append(result_record)

    output_path = Path(output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8") as f:
        json.dump(results, f, indent=2)

    logger.log_info("Run completed.", extra={"output": output, "num_results": len(results)})


if __name__ == "__main__":
    main()
