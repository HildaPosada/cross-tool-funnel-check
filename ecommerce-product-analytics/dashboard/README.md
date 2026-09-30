# Tableau dashboard build

Export actual BigQuery results, not mock data:

| Query | CSV filename | View |
|---|---|---|
| 01_event_audit.sql | event_audit.csv | Event coverage and missing identities |
| 02_unordered_funnel.sql | unordered_funnel.csv | Independent event reach |
| 03_ordered_funnel.sql | ordered_funnel.csv | Ordered funnel bars and step conversion |
| 04_weekly_retention.sql | weekly_retention.csv | Cohort heatmap |

Connect each CSV separately in Tableau. For the funnel: sort event_name by step_number; use users as bars and format conversion fields as percentages. For retention: rows=cohort_week, columns=week_number, color=retention_rate; include cohort_users in tooltip. Unobservable weeks have no row; never display them as zero retention.

Dashboard layout: title + date window, ordered funnel, cohort heatmap, definitions and limitations. Label retention as “First-observed-user weekly retention.” Publish only appropriate aggregate results after reviewing the source terms. Add the resulting Tableau Public URL to README. No packaged workbook is included because query outputs have not been produced.
