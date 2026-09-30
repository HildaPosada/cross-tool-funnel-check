# Cross-tool validation protocol

Status: not executed. This is a separate experiment, not a comparison of unrelated GA4 and Kaggle counts.

1. Select one documented source file and a small fixed time range. Record URL, license, SHA-256, row count, timezone, and extraction rule.
2. Retain all events for selected users in the range. Avoid independent row sampling, which can break sequences. Use a bounded slice that fits the chosen platform's current import limits.
3. Create a canonical extract with stable user_id, event_type, event_time, and a stable source-row event_id. Record handling of duplicates and missing values. Exclude personal information.
4. Load that exact extract into a separate BigQuery table and ONE analytics platform. Check current official import instructions; historical imports and default report windows require particular care. Never expose API keys in GitHub.
5. Confirm the same imported row count, distinct identities, event counts, minimum/maximum timestamps, and missing-value counts before comparing funnels.
6. Implement the actual source events in order. Match timezone, identity, strict ordering/tie policy, conversion window, date boundaries, session constraints, deduplication, and user counting in both tools. If the platform cannot match a rule, document that limitation and adjust both implementations to a shared rule.
7. Export the platform counts and SQL counts. Record exact differences and investigate every unexplained difference. Capture settings and screenshots. Do not call approximate agreement exact validation.

| Step | SQL users | Platform users | Platform minus SQL | Explained cause |
|---|---|---|---|---|
| View | pending | pending | pending | pending |
| Cart | pending | pending | pending | pending |
| Purchase | pending | pending | pending | pending |

Deliverables: extraction script/query, checksum, import log, SQL, settings screenshots, comparison CSV, discrepancy explanations. The GA4 ordered query can be adapted once the validation table schema is known.
