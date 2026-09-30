-- Unique users; any qualifying view entry in November UTC; 7-day elapsed conversion window.
-- Strict timestamp order at millisecond precision, matching Amplitude millisecond resolution.
WITH e AS (
 SELECT * FROM `lyrical-diagram-425923-h9.ecommerce_validation.events_200_users_v1`
 WHERE validation_batch = 'ga4_sample_200_users_v1'
), v AS (
 SELECT user_id, event_time_ms AS view_ms FROM e
 WHERE event_type='view_item'
 AND event_time_ms >= UNIX_MILLIS(TIMESTAMP('2020-11-01', 'UTC'))
 AND event_time_ms < UNIX_MILLIS(TIMESTAMP('2020-12-01', 'UTC'))
), c AS (
 SELECT v.user_id,v.view_ms,MIN(e.event_time_ms) AS cart_ms FROM v LEFT JOIN e
 ON v.user_id=e.user_id AND e.event_type='add_to_cart'
 AND e.event_time_ms>v.view_ms AND e.event_time_ms<=v.view_ms+604800000
 GROUP BY v.user_id,v.view_ms
), ch AS (
 SELECT c.user_id,c.view_ms,c.cart_ms,MIN(e.event_time_ms) AS checkout_ms FROM c LEFT JOIN e
 ON c.user_id=e.user_id AND e.event_type='begin_checkout'
 AND e.event_time_ms>c.cart_ms AND e.event_time_ms<=c.view_ms+604800000
 GROUP BY c.user_id,c.view_ms,c.cart_ms
), p AS (
 SELECT ch.user_id,ch.view_ms,ch.cart_ms,ch.checkout_ms,MIN(e.event_time_ms) AS purchase_ms FROM ch LEFT JOIN e
 ON ch.user_id=e.user_id AND e.event_type='purchase'
 AND e.event_time_ms>ch.checkout_ms AND e.event_time_ms<=ch.view_ms+604800000
 GROUP BY ch.user_id,ch.view_ms,ch.cart_ms,ch.checkout_ms
), counts AS (
 SELECT COUNT(DISTINCT user_id) AS viewed,
 COUNT(DISTINCT IF(cart_ms IS NOT NULL,user_id,NULL)) AS carted,
 COUNT(DISTINCT IF(checkout_ms IS NOT NULL,user_id,NULL)) AS checked_out,
 COUNT(DISTINCT IF(purchase_ms IS NOT NULL,user_id,NULL)) AS purchased FROM p
)
SELECT 1 AS step,'view_item' AS event,viewed AS users FROM counts
UNION ALL SELECT 2,'add_to_cart',carted FROM counts
UNION ALL SELECT 3,'begin_checkout',checked_out FROM counts
UNION ALL SELECT 4,'purchase',purchased FROM counts
ORDER BY step;
