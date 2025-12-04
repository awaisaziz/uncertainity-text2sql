# Uncertainty Text2SQL

Simple Text-to-SQL pipeline that reads the Spider dataset, builds schema-aware prompts, and sends questions to configurable LLM providers (OpenRouter or DeepSeek). The script collects generated SQL plus log-probability metadata and stores them in JSON along with rich logging.

## Project layout
- `main.py` – entry point; orchestrates loading data, building prompts, and writing outputs.
- `config/config.json` – default runtime configuration (paths, provider/model, delay, output target).
- `src/dataset/loader.py` – helpers to load `dev.json` and `tables.json` and pair questions with schemas.
- `src/prompts/` – prompt builders (currently zero-shot with system/user separation).
- `src/providers/` – provider adapters (OpenRouter and DeepSeek; both use an OpenAI-compatible client with logprobs enabled).
- `src/generator.py` – runs generation loop, cleaning outputs and writing JSON.
- `src/utils/` – logging setup and SQL text cleaning helpers.
- `logs/` – log files (created at runtime).
- `outputs/` – generated predictions (created at runtime).

## Prerequisites
- Python 3.10+
- Spider dataset available locally (expects `dev.json` and `tables.json` inside the dataset folder).
- Environment variables for providers (place in a `.env` loaded by your shell):
  - `OPENROUTER_API_KEY` for OpenRouter
  - `DEEPSEEK_API_KEY` for DeepSeek

## Configuration
Defaults live in `config/config.json`:
```json
{
  "dataset_path": "spider_data/",
  "default_provider": "openrouter",
  "default_model": "openrouter/deepseek-chat",
  "default_prompting_technique": "zero_shot",
  "num_query": 1,
  "max_tokens": 2048,
  "request_delay": 35.0,
  "output_file": "outputs/predicted_openrouter-deepseek-chat.json"
}
```
You can override any of these via CLI flags.

## Environment Setup (run from repo root)
1. Create and activate a Python virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Running
From the repository root:
```bash
python main.py --dataset_path spider_data/ --request_delay 5.0 --provider openrouter --model tngtech/deepseek-r1t-chimera:free --technique zero_shot --num_query 1 --output_file outputs/predicted_openrouter.json
```

Logs will be written to `logs/run_<timestamp>.log`. The outputs file contains entries shaped like:
```json
{
  "question_id": 1,
  "db_id": "database_name",
  "question": "How many employees are there?",
  "schema": "- table: column1, column2",
  "sql": "SELECT ...;",
  "logit_prob": -12.3
}
```

## Notes
- OpenRouter and DeepSeek calls request log probabilities (`logprobs`) to return token-level scores; they are aggregated into `logit_prob` in the output.
- The `request_delay` setting helps avoid rate limits when using real APIs.
