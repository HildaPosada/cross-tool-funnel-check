select 1 as step_order,'view_item' as event_name,count(distinct user_id) as users from {{ ref('int_funnel_paths') }}
union all select 2,'add_to_cart',count(distinct case when cart_ms is not null then user_id end) from {{ ref('int_funnel_paths') }}
union all select 3,'begin_checkout',count(distinct case when checkout_ms is not null then user_id end) from {{ ref('int_funnel_paths') }}
union all select 4,'purchase',count(distinct case when purchase_ms is not null then user_id end) from {{ ref('int_funnel_paths') }}
