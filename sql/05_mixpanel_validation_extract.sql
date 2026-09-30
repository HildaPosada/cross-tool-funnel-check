-- Deterministic event-level sample for a matched Mixpanel funnel test.
-- Cohort: first view_item from Nov 1 through Nov 30, 2020 (UTC).
-- Keep every selected user's funnel event in the seven days after that view.
-- Export the result as CSV; import this exact file into Mixpanel and BigQuery.
WITH source_events AS (
  SELECT
    user_pseudo_id,
    event_name,
    event_timestamp,
    TIMESTAMP_MICROS(event_timestamp) AS event_time_utc,
    TO_HEX(SHA256(TO_JSON_STRING(STRUCT(
      user_pseudo_id,
      event_name,
      event_timestamp,
      event_bundle_sequence_id,
      event_server_timestamp_offset
    )))) AS source_event_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201031' AND '20201209'
    AND event_name IN ('view_item', 'add_to_cart', 'begin_checkout', 'purchase')
    AND user_pseudo_id IS NOT NULL
    AND event_timestamp IS NOT NULL
), candidate_users AS (
  SELECT user_pseudo_id, MIN(event_time_utc) AS funnel_start_utc
  FROM source_events
  WHERE event_name = 'view_item'
    AND event_time_utc >= TIMESTAMP('2020-11-01 00:00:00+00')
    AND event_time_utc < TIMESTAMP('2020-12-01 00:00:00+00')
  GROUP BY user_pseudo_id
), sampled_users AS (
  SELECT user_pseudo_id, funnel_start_utc
  FROM candidate_users
  ORDER BY FARM_FINGERPRINT(user_pseudo_id), user_pseudo_id
  LIMIT 200
)
SELECT
  u.user_pseudo_id AS distinct_id,
  e.event_name AS event,
  FORMAT_TIMESTAMP('%Y-%m-%dT%H:%M:%E6SZ', e.event_time_utc, 'UTC') AS event_time_utc,
  e.event_timestamp AS event_timestamp_us,
  e.source_event_id,
  FORMAT_TIMESTAMP('%Y-%m-%dT%H:%M:%E6SZ', u.funnel_start_utc, 'UTC') AS funnel_start_utc
FROM sampled_users u
JOIN source_events e USING (user_pseudo_id)
WHERE e.event_time_utc >= u.funnel_start_utc
  AND e.event_time_utc < TIMESTAMP_ADD(u.funnel_start_utc, INTERVAL 7 DAY)
ORDER BY distinct_id, event_timestamp_us, event, source_event_id;