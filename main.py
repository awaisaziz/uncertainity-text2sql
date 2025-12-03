import argparse
import json
from datetime import datetime
from pathlib import Path

from src.dataset.loader import load_spider_split
from src.generator import PredictionGenerator
from src.prompts.zero_shot import ZeroShotPromptBuilder
from src.providers.deepseek import DeepSeekProvider
from src.providers.openrouter import OpenRouterProvider
from src.utils.logger import get_logger


def load_config(config_path: Path) -> dict:
    with config_path.open("r", encoding="utf-8") as f:
        return json.load(f)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run Text-to-SQL prediction over Spider dataset.")
    parser.add_argument("--dataset_path", default=None)
    parser.add_argument("--provider", default=None)
    parser.add_argument("--model", default=None)
    parser.add_argument("--technique", default=None)
    parser.add_argument("--num_query", type=int, default=None)
    parser.add_argument("--max_tokens", type=int, default=None)
    parser.add_argument("--request_delay", type=float, default=None)
    parser.add_argument("--output_file", default=None)
    parser.add_argument("--config", default="config/config.json", help="Path to config JSON file.")
    return parser.parse_args()


def build_provider(name: str):
    if name.lower() == "openrouter":
        return OpenRouterProvider()
    if name.lower() == "deepseek":
        return DeepSeekProvider()
    raise ValueError(f"Unsupported provider: {name}")


def build_prompt_builder(technique: str):
    if technique.lower() == "zero_shot":
        return ZeroShotPromptBuilder()
    raise ValueError(f"Unsupported prompting technique: {technique}")


def main() -> None:
    args = parse_args()
    config = load_config(Path(args.config))

    dataset_path = Path(args.dataset_path or config["dataset_path"])
    provider_name = args.provider or config["default_provider"]
    model_name = args.model or config["default_model"]
    technique = args.technique or config["default_prompting_technique"]
    num_query = args.num_query or config.get("num_query", 1)
    max_tokens = args.max_tokens or config.get("max_tokens", 2048)
    request_delay = args.request_delay if args.request_delay is not None else config.get("request_delay", 0.0)
    output_file = Path(args.output_file or config["output_file"])

    log_dir = Path("logs")
    log_name = f"run_{datetime.utcnow().strftime('%Y%m%dT%H%M%SZ')}.log"
    logger = get_logger(log_dir=log_dir, log_name=log_name)

    logger.info("Starting Text-to-SQL pipeline")
    logger.info(
        "Configuration - dataset: %s | provider: %s | model: %s | technique: %s | output: %s",
        dataset_path,
        provider_name,
        model_name,
        technique,
        output_file,
    )

    records = load_spider_split(dataset_path)
    logger.info("Loaded %d questions from %s", len(records), dataset_path)

    provider = build_provider(provider_name)
    prompt_builder = build_prompt_builder(technique)

    generator = PredictionGenerator(
        provider=provider,
        prompt_builder=prompt_builder,
        model=model_name,
        num_query=num_query,
        max_tokens=max_tokens,
        delay=request_delay,
        logger=logger,
        num_sample= 1
    )
    generator.generate(records, output_file)

    logger.info("Finished pipeline. Predictions stored at %s", output_file)
    logger.info("Log file available at %s/%s", log_dir, log_name)


if __name__ == "__main__":
    main()
