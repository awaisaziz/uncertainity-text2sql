# Uncertainty Text2SQL

Simple Text-to-SQL pipeline that reads the Spider dataset, builds schema-aware prompts, and sends questions to the DeepSeek Chat model. The script writes generated SQL candidates to JSON and records detailed logs for each run.

## Project layout
- `main.py` – entry point; orchestrates loading data, building prompts, and writing outputs.
- `config/config.json` – default runtime configuration (paths, provider/model, delay, output target).
- `src/dataset/loader.py` – helpers to load `dev.json` and `tables.json` and pair questions with schemas.
- `src/prompts/` – prompt builders (currently zero-shot with system/user separation).
- `src/llm/` – DeepSeek Chat client (loads `.env` for the API key).
- `src/generator.py` – runs the generation loop, cleaning outputs and writing JSON.
- `src/utils/` – logging setup and SQL text cleaning helpers.
- `logs/` – log files (created at runtime).
- `outputs/` – generated predictions (created at runtime).

## Prerequisites
- Python 3.10+
- Spider dataset available locally (expects `dev.json` and `tables.json` inside the dataset folder).
- Environment variable for DeepSeek (place in a `.env` loaded by your shell):
  - `DEEPSEEK_API_KEY`

## Configuration
Defaults live in `config/config.json`:
```json
{
  "dataset_path": "./spider_data/",
  "default_provider": "deepseek",
  "default_model": "deepseek-chat",
  "prompting_technique": "zero_shot",
  "num_sample": 1,
  "num_query": 3,
  "max_tokens": 2048,
  "request_delay": 0.0,
  "output_file": "outputs/predictions_deepseek.json"
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
python main.py --dataset_path spider_data/ --num_sample 1 --num_query 3 --max_tokens 2048 --output_file outputs/predictions_deepseek.json
```

Logs will be written to `logs/run_<timestamp>.log`, with a single file capturing the full session. The outputs file contains entries shaped like:
```json
{
  "dataset_path": "spider_data",
  "default_provider": "deepseek",
  "default_model": "deepseek-chat",
  "prompting_technique": "zero_shot",
  "num_sample": 1,
  "num_query": 3,
  "max_tokens": 2048,
  "generated": [
    {
      "id": 0,
      "question": "How many singers do we have?",
      "db_id": "concert_singer",
      "candidates": [
        { "sql": "SELECT COUNT(*) FROM singers;" },
        { "sql": "SELECT COUNT(*) FROM singer;" },
        { "sql": "SELECT COUNT(*) AS count FROM singer;" }
      ]
    }
  ]
}
```

## Notes
- The `request_delay` setting helps avoid rate limits when using real APIs.
