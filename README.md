# Text-to-SQL Scaffold with Uncertainty Placeholders

## Project Overview
This project provides a CLI-focused scaffold for experimenting with Text-to-SQL generation. It supports routing between DeepSeek and Gemini LLM providers, includes structured logging, and reserves extension points for Sequence-level Adaptive Calibration (SAC) and triplet-loss-based embeddings.

## Repository Structure
- `cli.py`: Command-line interface for batch Text-to-SQL runs.
- `main.py`: Helper entry point for high-level project description/logging.
- `config/`: Configuration loaders and defaults (`settings.py`, `defaults.py`, `config.json`).
- `models/`: Provider client wrappers and routing for DeepSeek and Gemini.
- `sac/`: Placeholders for SAC core logic, reranking, and triplet models.
- `generation/`: Text-to-SQL generation engine with logging hooks.
- `utils/`: Logger utilities and Spider dataset loader.
- `data/`: Placeholder location for datasets (no data included).
- `outputs/`: Generated outputs and run logs.
- `tests/`: Basic sanity tests for the scaffold.
- `.env.example`: Example environment configuration.
- `requirements.txt`: Python dependencies.

## Environment Setup
Create and activate a Python virtual environment:

```
python -m venv venv
source venv/bin/activate   # macOS/Linux
venv\Scripts\activate      # Windows
```

## Install Dependencies
Install the Python requirements:

```
pip install -r requirements.txt
```

## Configure `.env` + `config.json`
1. Copy `.env.example` to `.env` and populate API keys for DeepSeek and Gemini.
2. Adjust `config/config.json` if you need different default provider/model, dataset path, or generation limits.

## Running CLI
Execute Text-to-SQL generation with configurable techniques:

```
python cli.py \
    --dataset data/dev.json \
    --model deepseek-chat \
    --provider deepseek \
    --output outputs/run1.json \
    --technique zeroshot_sac \
    --num_samples 100
```

Techniques: `zeroshot`, `zeroshot_sac`, `zeroshot_triplet`.

## Extending SAC + TripletLoss
- Implement real uncertainty estimation in `sac/sac_core.py` and connect logits from provider responses.
- Enhance `sac/reranker.py` to reorder SQL candidates using SAC scores.
- Replace placeholder embeddings in `sac/triplet_model.py` with a learned model and integrate into the generation pipeline.

## Dataset link (no files in repo)
The Spider dataset is not bundled. Download it from the official source: https://yale-lily.github.io/spider and place the JSON file under `data/`.
