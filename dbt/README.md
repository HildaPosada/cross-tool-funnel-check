# dbt funnel exercise

Execution adapter: DuckDB locally. Executed successfully September 30, 2026: three models and 14 passing tests. BigQuery dbt deployment has not been run; dbt Fundamentals course completion remains unverified.

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

Complete dbt Fundamentals yourself. Explain `ref`, table materializations, the dependency graph, and why failing data tests return rows. The boundary exercise has been executed: changing the purchase to 604799999 with expected step three failed with one row, then changing the expectation to four passed. The fixture lives in `tests/adversarial_funnel_cases.sql`; its separate exact-boundary case still expects three. Repeat this exercise yourself to practice interpreting failures. List course completion only after completing it.
