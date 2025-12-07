import json
import os
import argparse

def get_base_filename(input_path: str) -> str:
    """Extract base filename without extension."""
    filename = os.path.basename(input_path)
    base, _ = os.path.splitext(filename)
    return base


def extract_simple_sql(data, output_dir, base_name):
    """
    Extract ONLY the first candidate SQL for each item.
    Store into: {base_name}_simple.txt
    """
    sql_list = []

    for item in data.get("generated", []):
        candidates = item.get("candidates", [])
        if candidates:
            sql_query = candidates[0].get("sql")
            if sql_query:
                sql_list.append(sql_query)

    os.makedirs(output_dir, exist_ok=True)

    output_path = os.path.join(output_dir, f"{base_name}_simple.sql")

    with open(output_path, "w") as f:
        for sql in sql_list:
            f.write(sql + "\n")

    print(f"[simple] Extracted {len(sql_list)} queries -> {output_path}")


def extract_sac_sql(data, output_dir, base_name):
    """
    Extract SAC-selected SQL options:
    - selected_sql_softmax
    - selected_sql_gmm
    - selected_sql_hybrid
    - selected_sql_robust

    Output files:
    {base_name}_sql_softmax.txt
    {base_name}_sql_gmm.txt
    {base_name}_sql_hybrid.txt
    {base_name}_sql_robust.txt
    """
    softmax_list = []
    gmm_list = []
    hybrid_list = []
    robust_list = []
    trainer_list = []
    
    for item in data.get("generated", []):
        if item.get("selected_sql_softmax"):
            softmax_list.append(item["selected_sql_softmax"])
        if item.get("selected_sql_gmm"):
            gmm_list.append(item["selected_sql_gmm"])
        if item.get("selected_sql_hybrid"):
            hybrid_list.append(item["selected_sql_hybrid"])
        if item.get("selected_sql_robust"):
            robust_list.append(item["selected_sql_robust"])
        if item.get("selected_sql_trainer"):
            trainer_list.append(item["selected_sql_trainer"])

    os.makedirs(output_dir, exist_ok=True)

    # Write Softmax file
    if softmax_list:
        path_softmax = os.path.join(output_dir, f"{base_name}_sql_softmax.sql")
        with open(path_softmax, "w") as f:
            for sql in softmax_list:
                f.write(sql + "\n")
        print(f"[sac] Softmax SQL -> {path_softmax}")

    # Write GMM file
    if gmm_list:
        path_gmm = os.path.join(output_dir, f"{base_name}_sql_gmm.sql")
        with open(path_gmm, "w") as f:
            for sql in gmm_list:
                f.write(sql + "\n")
        print(f"[sac] GMM SQL -> {path_gmm}")

    # Write Hybrid file
    if hybrid_list:
        path_hybrid = os.path.join(output_dir, f"{base_name}_sql_hybrid.sql")
        with open(path_hybrid, "w") as f:
            for sql in hybrid_list:
                f.write(sql + "\n")
        print(f"[sac] Hybrid SQL -> {path_hybrid}")
    
    # Write Robust file (same as Hybrid in this context)
    if robust_list:
        path_robust = os.path.join(output_dir, f"{base_name}_sql_robust.sql")
        with open(path_robust, "w") as f:
            for sql in robust_list:
                f.write(sql + "\n")
        print(f"[sac] Robust SQL -> {path_robust}")
    
    # Write Trainer file
    if trainer_list:
        path_trainer = os.path.join(output_dir, f"{base_name}_sql_trainer.sql")
        with open(path_trainer, "w") as f:
            for sql in trainer_list:
                f.write(sql + "\n")
        print(f"[sac] Trainer SQL -> {path_trainer}")


def main():
    parser = argparse.ArgumentParser(description="Extract SQL queries from JSON with mode selection.")

    parser.add_argument("--input_path", required=True, help="Path to the input JSON file")
    parser.add_argument("--output_dir", required=True, help="Directory to store the output files")
    parser.add_argument("--mode", required=True, choices=["simple", "sac"],
                        help="simple = first SQL candidate, sac = softmax/gmm/hybrid outputs")

    args = parser.parse_args()

    base_name = get_base_filename(args.input_path)

    # Load JSON
    with open(args.input_path, "r") as f:
        data = json.load(f)

    if args.mode == "simple":
        extract_simple_sql(data, args.output_dir, base_name)
    elif args.mode == "sac":
        extract_sac_sql(data, args.output_dir, base_name)


if __name__ == "__main__":
    main()
