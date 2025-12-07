import json
from pathlib import Path
from typing import Dict, Iterable, List, Tuple


def build_table_index(tables_json: List[Dict]) -> Dict[str, Dict]:
    index: Dict[str, Dict] = {}
    for entry in tables_json:
        table_names = entry.get("table_names_original") or entry.get("table_names")
        column_names = entry.get("column_names_original") or entry.get("column_names")
        index[entry["db_id"]] = {
            "table_names": table_names,
            "column_names": column_names,
        }
    return index


def table_schema_to_string(table_names: List[str], column_names: List[Tuple[int, str]]) -> str:
    schema_lines: List[str] = []
    for table_id, table_name in enumerate(table_names):
        columns = [name for idx, name in column_names if idx == table_id]
        line = f"- {table_name}: {', '.join(columns)}"
        schema_lines.append(line)
    return "\n".join(schema_lines)


def load_spider_split(dataset_path: Path) -> List[Dict]:
    dev_path = dataset_path / "dev.json"
    tables_path = dataset_path / "tables.json"

    with dev_path.open("r", encoding="utf-8") as f:
        dev_data = json.load(f)
    with tables_path.open("r", encoding="utf-8") as f:
        tables_data = json.load(f)

    table_index = build_table_index(tables_data)

    records: List[Dict] = []
    for item in dev_data:
        db_id = item["db_id"]
        question = item["question"]
        schema_meta = table_index.get(db_id, {})
        schema = table_schema_to_string(
            schema_meta.get("table_names", []), schema_meta.get("column_names", [])
        )
        records.append(
            {
                "question": question,
                "db_id": db_id,
                "schema": schema,
                "q_id": item.get("question_id") or item.get("id"),
            }
        )
    return records
