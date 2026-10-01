# Product Analytics: Funnel, Retention & Event Validation

I used Google's public ecommerce event sample to build a dashboard, then checked the same small event extract in BigQuery, Amplitude, and dbt.

**[Read the story behind the project](docs/case_study.md).** It explains what I found, the problem I ran into, and how I checked my work.

![Tableau dashboard showing the purchase funnel and weekly return activity](dashboard/dashboard-screenshot.jpg)

## What I found

In the full three-month sample, **61,252 visitor IDs viewed a product and 2,833 completed the purchase journey**. That is a **4.63% view-to-purchase rate**.

The largest drop came between viewing a product and adding it to a cart: **80.32%**. That identifies a stage to investigate. It does not establish the cause.

The dashboard also shows weekly return activity. Between **2.47% and 6.73%** of visitor IDs in groups with a fully observable following week returned that week. Any recorded event counts as activity.

[Explore the Tableau dashboard](https://public.tableau.com/views/EcommerceProductAnalyticsFunnelRetention/ConversionRetention).

## How I checked it

BigQuery and Amplitude counted the same 1,353-event, 200-visitor-ID extract and agreed at every step: **200 → 13 → 7 → 1**. The same calculation ran in three dbt models on BigQuery and DuckDB, with **14 passing tests on each**. Read the [case study](docs/case_study.md) for the story or the [validation results](docs/validation_results.md) for the counting rules and evidence.

## What to keep in mind

The data is Google's obfuscated GA4 ecommerce sample for November 2020 through January 2021. A visitor ID represents a browser or device, not a verified person.

The dashboard uses the full sample. The independent tool comparison uses a bounded 200-ID extract with different entry and follow-up rules. Agreement on that extract does not validate the full dashboard in Amplitude or explain why visitors drop out.

**dbt Fundamentals certification is in progress.** The analysis, dashboard, independent comparison, and dbt execution are complete. This remains a portfolio exercise rather than a production system.

## Check the work or run it yourself

- [Case study](docs/case_study.md): the plain-language story.
- [Validation results](docs/validation_results.md): counting rules, screenshots, and limitations.
- [Event dictionary](docs/event_dictionary.md): what the tracked events mean.
- [BigQuery SQL](sql/): source audit, dashboard calculations, and validation queries.
- [Aggregate results](data/exports/): the numbers behind the Tableau dashboard.
- [Dashboard setup](dashboard/README.md): how the views were built.
- [dbt project](dbt/README.md): models, tests, and commands for both databases.
- [BigQuery execution evidence](evidence/dbt_bigquery_summary.json): the actual warehouse run and funnel counts.
- [Resume project wording](docs/resume_project.md): a draft with the tools actually used.

Start with the [event audit](sql/01_event_audit.sql) when reproducing the source analysis. Use the [completed validation method and results](docs/validation_results.md) when comparing tools. Follow the [dbt instructions](dbt/README.md) to run the tested pipeline. Keep raw events and credentials out of Git.

Source: [Google's public GA4 ecommerce sample](https://developers.google.com/analytics/bigquery/web-ecommerce-demo-dataset).
