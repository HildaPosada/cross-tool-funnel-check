-- GoogleSQL. Inspect source completeness before interpreting funnels.
SELECT event_name, COUNT(*) AS event_rows,
  COUNT(DISTINCT user_pseudo_id) AS distinct_users,
  COUNTIF(user_pseudo_id IS NULL) AS missing_user_rows,
  COUNTIF(event_timestamp IS NULL) AS missing_timestamp_rows,
  MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_event_date,
  MAX(PARSE_DATE('%Y%m%d', event_date)) AS last_event_date
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY event_name
ORDER BY event_rows DESC;
