-- Preserve source rows and the same original millisecond precision.
{% if target.type == 'bigquery' %}
select user_id, event_type as event_name, event_time_ms, source_event_id
from {{ source('validation', 'events_200_users_v1') }}
{% else %}
select distinct_id as user_id, event as event_name,
       cast(event_timestamp_us as bigint) // 1000 as event_time_ms,
       source_event_id
from {{ ref('validation_events') }}
{% endif %}
