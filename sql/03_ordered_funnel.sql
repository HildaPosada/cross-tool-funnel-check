-- Strict timestamp order. Full-window, user-level, cross-session funnel.
WITH events AS (
  SELECT user_pseudo_id, event_name, event_timestamp
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND user_pseudo_id IS NOT NULL AND event_timestamp IS NOT NULL
    AND event_name IN ('view_item', 'add_to_cart', 'begin_checkout', 'purchase')
), views AS (
  SELECT user_pseudo_id, MIN(event_timestamp) AS view_ts
  FROM events WHERE event_name = 'view_item' GROUP BY user_pseudo_id
), carts AS (
  SELECT v.user_pseudo_id, v.view_ts, MIN(e.event_timestamp) AS cart_ts
  FROM views v LEFT JOIN events e ON e.user_pseudo_id = v.user_pseudo_id
    AND e.event_name = 'add_to_cart' AND e.event_timestamp > v.view_ts
  GROUP BY v.user_pseudo_id, v.view_ts
), checkouts AS (
  SELECT c.user_pseudo_id, c.view_ts, c.cart_ts, MIN(e.event_timestamp) AS checkout_ts
  FROM carts c LEFT JOIN events e ON e.user_pseudo_id = c.user_pseudo_id
    AND e.event_name = 'begin_checkout' AND e.event_timestamp > c.cart_ts
  GROUP BY c.user_pseudo_id, c.view_ts, c.cart_ts
), purchases AS (
  SELECT c.user_pseudo_id, c.view_ts, c.cart_ts, c.checkout_ts,
    MIN(e.event_timestamp) AS purchase_ts
  FROM checkouts c LEFT JOIN events e ON e.user_pseudo_id = c.user_pseudo_id
    AND e.event_name = 'purchase' AND e.event_timestamp > c.checkout_ts
  GROUP BY c.user_pseudo_id, c.view_ts, c.cart_ts, c.checkout_ts
), counts AS (
  SELECT COUNT(*) AS viewed, COUNTIF(cart_ts IS NOT NULL) AS carted,
    COUNTIF(checkout_ts IS NOT NULL) AS checked_out,
    COUNTIF(purchase_ts IS NOT NULL) AS purchased FROM purchases
), steps AS (
  SELECT 1 AS step_number, 'view_item' AS event_name, viewed AS users FROM counts
  UNION ALL SELECT 2, 'add_to_cart', carted FROM counts
  UNION ALL SELECT 3, 'begin_checkout', checked_out FROM counts
  UNION ALL SELECT 4, 'purchase', purchased FROM counts
)
SELECT *, SAFE_DIVIDE(users, FIRST_VALUE(users) OVER (ORDER BY step_number)) AS conversion_from_view,
  SAFE_DIVIDE(users, LAG(users) OVER (ORDER BY step_number)) AS conversion_from_previous,
  LAG(users) OVER (ORDER BY step_number) - users AS users_lost_from_previous
FROM steps ORDER BY step_number;
