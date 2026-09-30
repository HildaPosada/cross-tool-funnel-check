# Ecommerce Product Analytics

Portfolio project: event quality, ordered conversion funnels, weekly retention, and cross-tool reconciliation.

**Status:** starter implementation. No live queries have been executed; findings and dashboard links are pending. Do not present planned work as completed experience.

## Business questions
1. Where do users stop progressing from product view to purchase?
2. How often do observed users return in later calendar weeks?
3. Can independently implemented analytics tools reproduce a defined funnel on identical input?

## Start here
1. Open https://console.cloud.google.com/bigquery and select or create a project using the sandbox. No paid upgrade is necessary for this starter.
2. Use GoogleSQL and the US processing location. Paste `sql/01_event_audit.sql` into the query editor. Review estimated bytes before running.
3. Save the result to CSV as `event_audit.csv`.
4. Run the remaining SQL files separately and export results using the filenames in `dashboard/README.md`.
5. Connect the aggregate CSVs to Tableau. Keep each dataset separate to avoid multiplying counts through joins.
6. Complete `docs/validation_protocol.md` on a separate dataset before claiming cross-tool validation.

## Create the GitHub repository
Create an empty repository named `ecommerce-product-analytics` at https://github.com/new. Extract this package, open the extracted folder, and upload its contents with **Add file > Upload files**. Preserve the `sql`, `docs`, `dashboard`, and `data` folders. Open the repository and press `.` to edit in github.dev. ZIP contents must be extracted before upload.

## Metric contract
- Identity: non-null `user_pseudo_id`; browser/device identifier, not a verified person.
- Analysis: November 1, 2020 through January 31, 2021 inclusive.
- Unordered funnel: distinct users independently performing each event.
- Ordered funnel: first observed view, then earliest cart strictly later than that view, then earliest checkout strictly later than cart, then earliest purchase strictly later than checkout. Cross-session, cross-product, entire-window funnel; no fixed conversion timeout. Equal timestamps do not establish order.
- Retention: first **observed** activity week; any subsequent event qualifies as activity. Monday calendar weeks, using GA4 `event_date`. This is not acquisition retention or rolling seven-day retention.
- Cohort rows are exported only after the entire target calendar week is observable. Partial first/last source weeks are excluded.

## Sources and limitations
GA4 sample: https://developers.google.com/analytics/bigquery/web-ecommerce-demo-dataset
Sandbox: https://docs.cloud.google.com/bigquery/docs/sandbox

The GA4 sample is obfuscated and covers only three months. Treat findings as a methods demonstration, not a commercial recommendation. Timestamp order can differ from reporting-date boundaries. Missing identities, timestamp ties, repeat events, and finite observation affect interpretation. Existing sandbox tables expire; retain SQL and aggregate exports. Inspect actual query estimates rather than assuming a dataset size.

## Findings (complete after execution)
- Funnel counts and conversion: pending.
- Largest drop-off and proposed investigation: pending.
- Retention pattern and limitations: pending.
- Reconciliation discrepancies and root causes: pending.
- Tableau Public link: pending.
- Optional case study URL: pending.

## Suggested milestones
- First session: audit + unordered funnel (45–60 minutes).
- Week 1: ordered funnel, cohorts, metric definitions.
- Week 2: identical-input reconciliation and discrepancy log.
- Week 3: Tableau, findings, public portfolio write-up. Optional dbt learning and Vercel site can follow the core analysis.
