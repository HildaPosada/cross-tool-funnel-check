-- Shared validation copy: one constant shift preserves intervals and order.
-- Original 2020 dates remain in source_event_time_ms/source_event_timestamp_us.
CREATE TABLE IF NOT EXISTS `lyrical-diagram-425923-h9.ecommerce_validation.events_200_users_rebased_v2` AS
SELECT user_id,event_type,event_time_ms AS source_event_time_ms,
 event_time_ms+181353600000 AS event_time_ms,source_event_id,source_event_timestamp_us,
 funnel_start_utc,'ga4_sample_200_users_rebased_v2' AS validation_batch
FROM `lyrical-diagram-425923-h9.ecommerce_validation.events_200_users_v1`;
