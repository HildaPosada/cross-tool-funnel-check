-- Preserve every source row: tests, rather than silent filtering, enforce quality.
select distinct_id as user_id, event as event_name,
       cast(event_timestamp_us as bigint) // 1000 as event_time_ms,
       source_event_id
from {{ ref('validation_events') }}
