with t as (select *,lag(users) over(order by step_order) as previous_users from {{ ref('fct_funnel') }}) select * from t where users < 0 or users > previous_users
