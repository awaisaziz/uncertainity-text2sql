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
## Notes
- The `request_delay` setting helps avoid rate limits when using real APIs.

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

## SQL Extraction

Use `sql_extract.py` to extract all the required sql queries from the output predicted files and store only the sql queries in a separate folder. Later this file will be used for evaluation to report the results. There are 2 modes `simple` means take the first sql query from the candidate and second `sac` is to take the best sql from 3 different techniques softmax, GMM and hybrid.

```bash
python sql_extract.py --input_path outputs/llm/predictions_deepseek_chat_100.json --output_dir extracted_sql_for_evaluation/ --mode simple
```

and for using the sac mode we have the following prompt
```bash
python sql_extract.py --input_path outputs/llm/predictions_deepseek_chat_100.json --output_dir extracted_sql_for_evaluation/ --mode sac
```

## Evaluation

Use `evaluate.py` to call the official Spider evaluation script and obtain exact match and execution accuracy metrics:

```bash
python install.py
```

```bash
python evaluation.py --gold spider_data/dev_gold.sql --db spider_data/database --table spider_data/tables.json --pred extracted_sql_for_evaluation/predictions_deepseek_chat_100_simple.sql --etype all
```

The script will create a temporary `.sql` file, run `spider_data/evaluate.py`, and print the reported metrics.
