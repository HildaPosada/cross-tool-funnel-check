# Tableau dashboard build

Export actual BigQuery results, not mock data:

| Query | CSV export | View |
|---|---|---|
| `../sql/01_event_audit.sql` | `../data/exports/event_audit.csv` | Event coverage and missing identities |
| `../sql/02_unordered_funnel.sql` | `../data/exports/unordered_funnel.csv` | Independent event reach |
| `../sql/03_ordered_funnel.sql` | `../data/exports/ordered_funnel.csv` | Ordered funnel bars and step conversion |
| `../sql/04_weekly_retention.sql` | `../data/exports/weekly_retention.csv` | Cohort heatmap |

Connect each CSV in `../data/exports/` separately in Tableau. For the funnel: sort event_name by step_number; use users as bars and format conversion fields as percentages. For retention: rows=cohort_week, columns=week_number, color=retention_rate; include cohort_users in tooltip. Unobservable weeks have no row; never display them as zero retention.

Dashboard layout: title + date window, ordered funnel, cohort heatmap, definitions and limitations. Label retention as “First-observed-user weekly retention.” Publish only appropriate aggregate results after reviewing the source terms. The live Tableau Public dashboard and screenshot are linked from the project [README](../README.md). No packaged Tableau workbook is stored in this repository.
