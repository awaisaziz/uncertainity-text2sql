# VeriSQL: Uncertainty-Aware Text2SQL Verification and Reranking

VeriSQL is an uncertainty-aware Text-to-SQL system that extends a simple generation pipeline into a full verification, scoring, and reranking framework.
It reads the Spider dataset (dev.json), builds schema-aware prompts, generates multiple candidate SQL queries using the **deepseek-chat** model, and then applies semantic similarity, consensus metrics, Gaussian Mixture Models (GMM), execution checks, and hybrid scoring to identify the most reliable SQL query.

The system stores all generated candidates, computes detailed uncertainty scores (Softmax, GMM posterior, semantic entropy, execution agreement), and outputs both raw predictions and reranked results. Comprehensive logs are also captured for every run.

## Project layout
- `main.py` – entry point; orchestrates loading data, building prompts, and writing outputs.
- `config/config.json` – default runtime configuration (paths, provider/model, delay, mode, and output targets).
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
  "num_sample": 1,
  "num_query": 1,
  "max_tokens": 2048,
  "request_delay": 0.0,
  "mode": "generate",
  "output_llm": "outputs/llm/deepseek_chat_one_candidate_query.json",
  "output_rerank": "outputs/reranked/deepseek_chat_one_candidate_query_reranked.json"
}
```
## Notes
- The `num_query` setting controls how many SQL candidates are requested in a single LLM response. The prompt expects the model to return a JSON array with exactly this many `sql` entries.
- The `request_delay` setting helps avoid rate limits when using real APIs.
- `mode` controls whether the CLI runs online generation (`generate`) or offline reranking (`rerank`).

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
python main.py --mode generate --dataset_path spider_data/ --num_sample 100 --num_query 1 --max_tokens 6000 --output_llm outputs/llm/predictions_deepseek.json
```

Logs will be written to `logs/run_<timestamp>.log`, with a single file capturing the full session. The generation output contains entries shaped like:
```json
{
  "dataset_path": "spider_data",
  "default_provider": "deepseek",
  "default_model": "deepseek-chat",
  "mode": "generate",
  "num_sample": 1,
  "num_query": 3,
  "max_tokens": 2048,
  "generated": [
    {
        "id": 0,
        "question": "How many singers do we have?",
        "db_id": "concert_singer",
        "candidates": [
        { "sql": "SELECT COUNT(*) FROM singer;" },
        { "sql": "SELECT COUNT(singer_id) FROM singer;" },
        { "sql": "SELECT COUNT(*) FROM (SELECT DISTINCT singer_id FROM singer) t;" }
        ]
      }
    ]
}
```

The zero-shot prompt used for generation is:

```
Given this database schema:
{schema}

Question: {question}

Generate exactly {n} different, correct SQL queries that answer the question.
Each query must use a different SQL approach. Return ONLY a JSON array with {n} objects.

Format: [{"sql": "query1"}, {"sql": "query2"}, ...]
```

### Offline reranking
After collecting LLM outputs, run the semantic consensus reranker:

```bash
python main.py --mode rerank --output_llm outputs/llm/predictions_deepseek.json --output_rerank outputs/reranked/predictions_deepseek_reranked.json
```

The reranker computes cosine similarity, consensus, softmax probabilities, GMM posteriors, semantic entropy, GMM entropy, and three strategies (softmax-only, GMM-only, hybrid). It writes both the specified reranked file and a convenience copy named `reranked_output.json` inside the reranked output directory.

## SQL Extraction

Use `sql_extract.py` to extract all the required sql queries from the output predicted files and store only the sql queries in a separate folder. Later this file will be used for evaluation to report the results. There are 2 modes `simple` means take the first sql query from the candidate and second `sac` is to take the best sql from 3 different techniques softmax, GMM and hybrid.

```bash
python sql_extract.py --input_path outputs/llm/deepseek_chat_one_candidate_query.json --output_dir extracted_sql_for_evaluation/ --mode simple
```

and for using the sac mode we have the following prompt
```bash
python sql_extract.py --input_path outputs/reranked/deepseek_chat_k=4_reranked.json --output_dir extracted_sql_for_evaluation/ --mode sac
```

## Evaluation

Use `evaluate.py` to call the official Spider evaluation script and obtain exact match and execution accuracy metrics:

```bash
python install.py
```

```bash
python evaluation.py --gold spider_data/dev_gold.sql --db spider_data/database --table spider_data/tables.json --pred extracted_sql_for_evaluation/deepseek_chat_k=4_reranked_sql_robust.sql --etype all
```

The script will create a temporary `.sql` file, run `spider_data/evaluate.py`, and print the reported metrics.

## Experimental Results (deepseek-chat as SQL Generator)

In all the experiments, the **deepseek-chat** model is used as the underlying SQL generator. Different values of **k** indicate how many SQL candidates are sampled per query.

* **k = 1** serves as the **baseline**, representing the model’s default single output prediction without reranking or uncertainty modelling.
* For **k > 1**, various reranking methods are applied to select the final SQL.

The table below reports execution accuracy and exact match scores using **first 100 queries sampled from the Spider 1.0 `dev.json` file**.

### Performance Comparison Across Reranking Methods

| **Method (k)**       | **Execution Acc (%)** | **Exact Match (%)** |
| -------------------- | --------------------- | ------------------- |
| **Baseline (k = 1)** | 65                    | 45                  |
| **GMM (k = 4)**      | 53                    | 43                  |
| **Hybrid (k = 4)**   | 60                    | 41                  |
| **Robust (k = 4)**   | 69                    | 46                  |
| **GMM (k = 5)**      | 60                    | 48                  |
| **Hybrid (k = 5)**   | 60                    | 48                  |
| **Robust (k = 5)**   | 60                    | 45                  |
| **GMM (k = 8)**      | 62                    | 45                  |
| **Hybrid (k = 8)**   | 60                    | 43                  |
| **Robust (k = 8)**   | **71**                | **55**              |

The **best-performing** method for each setting is shown in **bold**.

## Dataset Download

To run this project, you need the **Spider 1.0** dataset, which provides the natural language questions, gold SQL queries, and database files used for evaluation.

### 📦 Download Links

* **Spider 1.0 Dataset (Google Drive):**
  [https://drive.google.com/file/d/1403EGqzIDoHMdQF4c9Bkyl7dZLZ5Wt6J/view](https://drive.google.com/file/d/1403EGqzIDoHMdQF4c9Bkyl7dZLZ5Wt6J/view)

* **Official Spider GitHub Repository:**
  [https://github.com/taoyds/spider](https://github.com/taoyds/spider)

### 🔧 How the Dataset Is Used

* **`dev.json`** — evaluation questions used by your pipeline
* **`tables.json`** — database schema definitions used in prompt construction
* **`database/`** — actual SQLite databases used for execution accuracy

Make sure you set your config properly:

```json
{
  "dataset_path": "./spider_data/"
}
```

