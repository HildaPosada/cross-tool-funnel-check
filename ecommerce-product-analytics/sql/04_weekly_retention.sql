-- First-observed-user cohorts. Only fully observable Monday–Sunday weeks.
WITH activity AS (
  SELECT DISTINCT user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d', event_date), WEEK(MONDAY)) AS activity_week
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND user_pseudo_id IS NOT NULL
), first_seen AS (
  SELECT user_pseudo_id, MIN(activity_week) AS cohort_week
  FROM activity GROUP BY user_pseudo_id
), sizes AS (
  SELECT cohort_week, COUNT(*) AS cohort_users FROM first_seen
  WHERE cohort_week >= DATE '2020-11-01' GROUP BY cohort_week
), retained AS (
  SELECT f.cohort_week, a.activity_week, COUNT(*) AS active_users
  FROM first_seen f JOIN activity a USING (user_pseudo_id)
  GROUP BY f.cohort_week, a.activity_week
), grid AS (
  SELECT s.*, activity_week
  FROM sizes s CROSS JOIN UNNEST(GENERATE_DATE_ARRAY(
    s.cohort_week, DATE_SUB(DATE '2021-01-31', INTERVAL 6 DAY), INTERVAL 7 DAY)) AS activity_week
)
SELECT g.cohort_week, g.activity_week,
  DATE_DIFF(g.activity_week, g.cohort_week, WEEK(MONDAY)) AS week_number,
  g.cohort_users, COALESCE(r.active_users, 0) AS active_users,
  SAFE_DIVIDE(COALESCE(r.active_users, 0), g.cohort_users) AS retention_rate
FROM grid g LEFT JOIN retained r
  ON g.cohort_week = r.cohort_week AND g.activity_week = r.activity_week
ORDER BY cohort_week, week_number;
