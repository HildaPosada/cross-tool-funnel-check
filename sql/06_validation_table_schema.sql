-- Load the locally prepared exact event extract using BigQuery Create table → Upload.
-- Use newline-delimited JSON, autodetect OFF, and the matching explicit fields below.
CREATE SCHEMA IF NOT EXISTS `lyrical-diagram-425923-h9.ecommerce_validation` OPTIONS(location='US');
-- Canonical original table schema:
-- user_id STRING, event_type STRING, event_time_ms INT64, source_event_id STRING,
-- source_event_timestamp_us INT64, funnel_start_utc STRING, validation_batch STRING.
-- For prepare_validation.py's already-rebased NDJSON use events_200_users_rebased_v2
-- and additionally source_event_time_ms INT64. Do not rebase that file a second time.
