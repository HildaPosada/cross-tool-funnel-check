-- Independent reach counts: this does not enforce event sequence.
WITH events AS (
  SELECT user_pseudo_id, event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND user_pseudo_id IS NOT NULL
    AND event_name IN ('view_item', 'add_to_cart', 'begin_checkout', 'purchase')
)
SELECT CASE event_name WHEN 'view_item' THEN 1 WHEN 'add_to_cart' THEN 2
    WHEN 'begin_checkout' THEN 3 WHEN 'purchase' THEN 4 END AS step_number,
  event_name, COUNT(DISTINCT user_pseudo_id) AS users
FROM events
GROUP BY event_name
ORDER BY step_number;
