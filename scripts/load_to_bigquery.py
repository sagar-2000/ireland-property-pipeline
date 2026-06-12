"""
One-time script to load the Irish PPR CSV into BigQuery.
Run this once after downloading the PPR data.
"""

import os
from google.cloud import bigquery

PROJECT_ID = "ireland-property-pipeline"
DATASET_ID = "raw_data"
TABLE_ID = "property_price_register"
CSV_PATH = os.path.join(os.path.dirname(__file__), "../data/ppr-all.csv")

SCHEMA = [
    bigquery.SchemaField("date_of_sale", "STRING"),
    bigquery.SchemaField("address", "STRING"),
    bigquery.SchemaField("county", "STRING"),
    bigquery.SchemaField("eircode", "STRING"),
    bigquery.SchemaField("price", "STRING"),
    bigquery.SchemaField("not_full_market_price", "STRING"),
    bigquery.SchemaField("vat_exclusive", "STRING"),
    bigquery.SchemaField("description_of_property", "STRING"),
    bigquery.SchemaField("property_size_description", "STRING"),
]


def main():
    client = bigquery.Client(project=PROJECT_ID)

    # Create dataset if it doesn't exist
    dataset_ref = bigquery.Dataset(f"{PROJECT_ID}.{DATASET_ID}")
    dataset_ref.location = "EU"
    client.create_dataset(dataset_ref, exists_ok=True)
    print(f"Dataset {DATASET_ID} ready.")

    table_ref = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"

    job_config = bigquery.LoadJobConfig(
        schema=SCHEMA,
        skip_leading_rows=1,
        source_format=bigquery.SourceFormat.CSV,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
        encoding="UTF-8",
    )

    with open(CSV_PATH, "rb") as f:
        job = client.load_table_from_file(f, table_ref, job_config=job_config)

    print(f"Loading {CSV_PATH} into {table_ref} ...")
    job.result()  # Wait for job to complete

    table = client.get_table(table_ref)
    print(f"Loaded {table.num_rows:,} rows into {table_ref}")


if __name__ == "__main__":
    main()
