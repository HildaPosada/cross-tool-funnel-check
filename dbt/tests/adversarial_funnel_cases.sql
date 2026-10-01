-- Synthetic cases independently specify expected outcomes: ties, wrong order,
-- exclusive seven-day boundary, and a valid later entry after an earlier failure.
with fixture as (
select 'valid' as user_id, 'view_item' as event_name, 0 as event_time_ms
union all
select 'valid' as user_id, 'add_to_cart' as event_name, 1 as event_time_ms
union all
select 'valid' as user_id, 'begin_checkout' as event_name, 2 as event_time_ms
union all
select 'valid' as user_id, 'purchase' as event_name, 3 as event_time_ms
union all
select 'tie' as user_id, 'view_item' as event_name, 0 as event_time_ms
union all
select 'tie' as user_id, 'add_to_cart' as event_name, 0 as event_time_ms
union all
select 'wrong' as user_id, 'view_item' as event_name, 0 as event_time_ms
union all
select 'wrong' as user_id, 'begin_checkout' as event_name, 1 as event_time_ms
union all
select 'wrong' as user_id, 'add_to_cart' as event_name, 2 as event_time_ms
union all
select 'wrong' as user_id, 'purchase' as event_name, 3 as event_time_ms
union all
select 'boundary' as user_id, 'view_item' as event_name, 0 as event_time_ms
union all
select 'boundary' as user_id, 'add_to_cart' as event_name, 1 as event_time_ms
union all
select 'boundary' as user_id, 'begin_checkout' as event_name, 2 as event_time_ms
union all
select 'boundary' as user_id, 'purchase' as event_name, 604799999 as event_time_ms
union all
select 'exact' as user_id, 'view_item' as event_name, 0 as event_time_ms
union all
select 'exact' as user_id, 'add_to_cart' as event_name, 1 as event_time_ms
union all
select 'exact' as user_id, 'begin_checkout' as event_name, 2 as event_time_ms
union all
select 'exact' as user_id, 'purchase' as event_name, 604800000 as event_time_ms
union all
select 'later' as user_id, 'view_item' as event_name, 0 as event_time_ms
union all
select 'later' as user_id, 'view_item' as event_name, 604800000 as event_time_ms
union all
select 'later' as user_id, 'add_to_cart' as event_name, 604800001 as event_time_ms
union all
select 'later' as user_id, 'begin_checkout' as event_name, 604800002 as event_time_ms
union all
select 'later' as user_id, 'purchase' as event_name, 604800003 as event_time_ms
), paths as ({{ ordered_paths('fixture') }}), actual as (
 select user_id,max(case when purchase_ms is not null then 4 when checkout_ms is not null then 3 when cart_ms is not null then 2 else 1 end) as step from paths group by user_id
), expected as (select 'valid' as user_id,4 as step union all select 'tie',1 union all select 'wrong',2 union all select 'boundary',4 union all select 'later',4 union all select 'exact',3)
select e.*,a.step as actual_step from expected e left join actual a using(user_id) where a.step is null or e.step<>a.step
