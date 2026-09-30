"""Prepare matching Amplitude and BigQuery inputs; keep generated raw files local."""
import argparse, csv, json
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("source_csv", type=Path)
parser.add_argument("output_dir", type=Path)
args = parser.parse_args()
args.output_dir.mkdir(parents=True, exist_ok=True)
rows = list(csv.DictReader(args.source_csv.open()))
assert len({r["source_event_id"] for r in rows}) == len(rows), "Duplicate source IDs"
shift = 181353600000
canonical, amplitude = [], []
for r in rows:
    assert all(r.values()), "Missing required value"
    original_ms = int(r["event_timestamp_us"]) // 1000
    event_ms = original_ms + shift
    row = dict(user_id=r["distinct_id"], event_type=r["event"],
        source_event_time_ms=original_ms, event_time_ms=event_ms,
        source_event_id=r["source_event_id"],
        source_event_timestamp_us=int(r["event_timestamp_us"]),
        funnel_start_utc=r["funnel_start_utc"],
        validation_batch="ga4_sample_200_users_rebased_v2")
    canonical.append(row)
    amplitude.append(dict(user_id=row["user_id"], event_type=row["event_type"],
        time=event_ms, insert_id="rebased_v2_" + row["source_event_id"],
        event_properties=dict(validation_batch=row["validation_batch"],
            source_event_id=row["source_event_id"],
            source_event_timestamp_us=str(row["source_event_timestamp_us"]),
            timestamp_shift_ms=shift)))
(args.output_dir / "bigquery_events.ndjson").write_text(
    "".join(json.dumps(r) + "\n" for r in canonical))
(args.output_dir / "amplitude_events.json").write_text(json.dumps(amplitude, indent=2))
print(f"Prepared {len(rows)} events from {len({r['user_id'] for r in canonical})} users")
