# 🏠 Ireland Residential Property Market — ELT Pipeline & Dashboard

An end-to-end data engineering project built on the Irish Property Price Register (PPR) — 788,000+ property transactions from 2010 to 2025.

## 🔧 Tech Stack

| Layer | Tool |
|---|---|
| Data Source | [Irish Property Price Register](https://www.propertypriceregister.ie) |
| Data Warehouse | Google BigQuery |
| Transformation | dbt Core |
| Visualisation | Looker Studio |
| Language | SQL, Python |

## 📐 Architecture

```
PPR CSV (788k rows)
    ↓
Python ingestion script
    ↓
BigQuery (raw_data.property_price_register)
    ↓
dbt staging layer (stg_property_prices)
    ↓
dbt mart layer
    ├── mart_county_trends        # Avg/median price by county & year + YoY growth
    ├── mart_dublin_analysis      # Dublin breakdown by postcode
    └── mart_dublin_postcodes_geo # Dublin postcodes with lat/lng for map visualisation
    ↓
Looker Studio Dashboard (2 pages)
    ├── Page 1 — National view   # Ireland bubble map, price trends, YoY growth
    └── Page 2 — Dublin drill-down # Postcode map, price by area, median vs avg
```

## 📊 Dashboard

👉 [View Live Dashboard](#) <!-- replace with your Looker Studio share link -->

**Page 1 — National Overview**
- Ireland bubble map: avg price by county
- National average price trend 2010–2025
- Year-on-Year price growth (%)
- Scorecards: total transactions, national avg, YoY growth

**Page 2 — Dublin Deep Dive**
- Dublin postcode map (Google Maps with lat/lng bubbles)
- Avg price by postcode bar chart
- Total transactions by postcode
- Median vs average price comparison

## 🗂️ dbt Models

```
models/
├── staging/
│   ├── sources.yml               # BigQuery raw source definition
│   └── stg_property_prices.sql   # Cleaned & typed staging view
└── marts/
    ├── mart_county_trends.sql    # County-level aggregations + YoY
    ├── mart_dublin_analysis.sql  # Dublin postcode aggregations
    ├── mart_dublin_postcodes_geo.sql  # Geo-enriched Dublin data
    └── schema.yml                # Model documentation & tests
```

## 🔑 Key Insights

- Irish property prices **bottomed in 2013** (~€150k national avg) following the 2008 crash
- Prices have **risen 150%+ since 2013**, reaching €400k+ nationally in 2025
- **Dublin commands a 2x premium** over the national median
- **D06 and D04** consistently rank as the most expensive Dublin postcodes
- YoY growth spiked in **2021–2022** during the post-Covid supply crisis

## ⚙️ Setup

### Prerequisites
- Python 3.8+
- Google Cloud account with BigQuery enabled
- dbt Core (`pip install dbt-bigquery`)

### Run the pipeline

```bash
# Install dependencies
pip install -r requirements.txt

# Set GCP credentials
export GOOGLE_APPLICATION_CREDENTIALS="path/to/your/keyfile.json"

# Load raw data into BigQuery
python scripts/load_to_bigquery.py

# Run dbt models
cd dbt_project
dbt run --profiles-dir .

# Run data quality tests
dbt test --profiles-dir .
```

## 📁 Project Structure

```
housing_analysis/
├── data/                    # Raw PPR CSV (not tracked in git)
├── scripts/
│   └── load_to_bigquery.py  # One-time ingestion script
├── dbt_project/
│   ├── dbt_project.yml
│   ├── profiles.yml
│   └── models/
│       ├── staging/
│       └── marts/
└── requirements.txt
```
