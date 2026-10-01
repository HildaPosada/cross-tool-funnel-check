# Event dictionary

| Source event | Meaning | Funnel step | Identity / timing |
|---|---|---|---|
| view_item | Recorded product detail view | 1 | user_pseudo_id / event_timestamp |
| add_to_cart | Recorded cart addition | 2 | Same |
| begin_checkout | Recorded checkout initiation | 3 | Same |
| purchase | Recorded purchase event; not independently verified payment | 4 | Same |
| Any event | Activity for weekly retention | None | user_pseudo_id / event_date |

Counts describe recorded behavior. A user may view one product and buy another. Duplicate event rows do not inflate distinct-user counts but must be audited before event-count metrics. Missing identities are excluded from funnel and retention, and reported by the audit.
