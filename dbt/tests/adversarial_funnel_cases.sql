-- Synthetic cases independently specify expected outcomes: ties, wrong order,
-- exclusive seven-day boundary, and a valid later entry after an earlier failure.
with fixture(user_id,event_name,event_time_ms) as (values
 ('valid','view_item',0),('valid','add_to_cart',1),('valid','begin_checkout',2),('valid','purchase',3),
 ('tie','view_item',0),('tie','add_to_cart',0),
 ('wrong','view_item',0),('wrong','begin_checkout',1),('wrong','add_to_cart',2),('wrong','purchase',3),
 ('boundary','view_item',0),('boundary','add_to_cart',1),('boundary','begin_checkout',2),('boundary','purchase',604800000),
 ('later','view_item',0),('later','view_item',604800000),('later','add_to_cart',604800001),('later','begin_checkout',604800002),('later','purchase',604800003)
), paths as ({{ ordered_paths('fixture') }}), actual as (
 select user_id,max(case when purchase_ms is not null then 4 when checkout_ms is not null then 3 when cart_ms is not null then 2 else 1 end) as step from paths group by user_id
), expected(user_id,step) as (values ('valid',4),('tie',1),('wrong',2),('boundary',3),('later',4))
select e.*,a.step as actual_step from expected e left join actual a using(user_id) where a.step is null or e.step<>a.step
