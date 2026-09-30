select * from {{ ref('fct_funnel') }} where users <> case step_order when 1 then 200 when 2 then 13 when 3 then 7 when 4 then 1 else -1 end
