#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
python3 -m venv .venv-bigquery
.venv-bigquery/bin/pip install dbt-core==1.12.5 dbt-bigquery==1.12.1 > install-bigquery.log 2>&1
DBT_BIGQUERY_ACCESS_TOKEN="$(gcloud auth print-access-token)"
export DBT_BIGQUERY_ACCESS_TOKEN
.venv-bigquery/bin/dbt debug --profiles-dir . --target bigquery 2>&1 | tee debug-bigquery.log
.venv-bigquery/bin/dbt build --profiles-dir . --target bigquery 2>&1 | tee build-bigquery.log
cp target/run_results.json build-run-results.json
.venv-bigquery/bin/dbt docs generate --profiles-dir . --target bigquery 2>&1 | tee docs-bigquery.log
.venv-bigquery/bin/python - <<'RESULTS'
import json
from google.cloud import bigquery
import os
from google.oauth2.credentials import Credentials
c=bigquery.Client(project='lyrical-diagram-425923-h9', credentials=Credentials(token=os.environ['DBT_BIGQUERY_ACCESS_TOKEN']))
rows=list(c.query('select * from `lyrical-diagram-425923-h9.ecommerce_validation.fct_funnel` order by step_order').result())
a=json.load(open('build-run-results.json'))
s={'adapter':'bigquery','dbt_version':a['metadata']['dbt_version'],'executed_at':a['metadata']['generated_at'],'project':'lyrical-diagram-425923-h9','dataset':'ecommerce_validation','source_table':'events_200_users_v1','funnel':[dict(r.items()) for r in rows],'build_results':[{'node':r['unique_id'],'status':r['status'],'failures':r.get('failures')} for r in a['results']]}
json.dump(s,open('bigquery-summary.json','w'),indent=2)
print(json.dumps(s,indent=2))
RESULTS
