# dbt funnel exercise

Execution adapter: DuckDB locally. This is practical dbt evidence; dbt BigQuery deployment and dbt Fundamentals course completion are still pending.

## Reproduce

Use Python 3.12 in a virtual environment and install `pip install -r requirements.txt`. Copy the original hashed 1,353-row validation CSV into `seeds/validation_events.csv`. From this directory run:

```
dbt build --profiles-dir .
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
```

Raw events, the local database, logs and generated artifacts are excluded from Git. Baseline tests intentionally require the identical validation sample.

## Models

`stg_events` preserves source rows and floors microseconds to milliseconds. `int_funnel_paths` evaluates each view as a possible entry and selects successive events with strictly increasing timestamps. `fct_funnel` counts distinct users reaching each step. The window is seven elapsed days, with an exclusive upper bound. The finite extract can censor later entries; this is the sample comparison, not the full Tableau population.

The independent BigQuery/Amplitude baseline is 200 → 13 → 7 → 1. Tests check required fields, unique event identifiers, accepted events, sample coverage, baseline counts, monotonicity, order and window boundaries. A synthetic fixture checks ties, wrong order, the seven-day deadline and successful later entry.

## Learn by changing it

Complete dbt Fundamentals yourself. Explain `ref`, table materializations, the dependency graph, and why failing data tests return rows. Then change the synthetic boundary purchase to 604799999, change its expected step to four, and rerun that test. List course completion only after completing it.
