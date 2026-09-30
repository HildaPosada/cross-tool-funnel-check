{% macro ordered_paths(relation) %}
with views as (
 select user_id, event_time_ms as view_ms from {{ relation }}
 where event_name = 'view_item'
), carts as (
 select v.user_id, v.view_ms, min(e.event_time_ms) as cart_ms
 from views v left join {{ relation }} e on v.user_id=e.user_id
 and e.event_name='add_to_cart' and e.event_time_ms>v.view_ms
 and e.event_time_ms<v.view_ms+604800000
 group by v.user_id,v.view_ms
), checkouts as (
 select c.user_id,c.view_ms,c.cart_ms,min(e.event_time_ms) as checkout_ms
 from carts c left join {{ relation }} e on c.user_id=e.user_id
 and e.event_name='begin_checkout' and e.event_time_ms>c.cart_ms
 and e.event_time_ms<c.view_ms+604800000
 group by c.user_id,c.view_ms,c.cart_ms
)
select c.user_id,c.view_ms,c.cart_ms,c.checkout_ms,min(e.event_time_ms) as purchase_ms
from checkouts c left join {{ relation }} e on c.user_id=e.user_id
and e.event_name='purchase' and e.event_time_ms>c.checkout_ms
and e.event_time_ms<c.view_ms+604800000
group by c.user_id,c.view_ms,c.cart_ms,c.checkout_ms
{% endmacro %}
