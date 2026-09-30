select count(*) as rows, count(distinct user_id) as users from {{ ref('stg_events') }} having count(*) <> 1353 or count(distinct user_id) <> 200
