--课本
insert overwrite table ads_user_action_convert_day
select 
    '2019-02-10',
    uv.day_count,
    ua.order_count,
    cast(ua.order_count/uv.day_count as  decimal(10,2)) visitor2order_convert_ratio,
    ua.payment_count,
    cast(ua.payment_count/ua.order_count as  decimal(10,2)) order2payment_convert_ratio
from  
(
select 
        dt,
        sum(if(order_count>0,1,0)) order_count,
        sum(if(payment_count>0,1,0)) payment_count
    from dws_user_action
    where dt='2019-02-10'
group by dt
) ua 
join ads_uv_count  uv on uv.dt=ua.dt;



















--扩展
insert overwrite table ads_user_action_convert_day_2
select 
    '2019-02-10',
    uv.day_count,
    dc.deatil_count,
    cast(dc.deatil_count/uv.day_count as  decimal(10,2)) visitor2detail_convert_ratio,
    ua.order_count,
    cast(ua.order_count/dc.deatil_count as  decimal(10,2)) detail2order_convert_ratio,
    ua.payment_count,
    cast(ua.payment_count/ua.order_count as  decimal(10,2)) order2payment_convert_ratio
from  
(
select 
    dt,
    sum(if(order_count>0,1,0)) order_count,
    sum(if(payment_count>0,1,0)) payment_count
    from dws_user_action
    where dt='2019-02-10'
    group by dt
)ua ,
(   
select
    dt1,
    count(*) deatil_count
from
    (select 
        dt dt1,
        user_id user_id1,
        mid_id
    from dwd_newsdetail_log nl
    where dc.dt1='2019-02-10';
    group by nl.user_id,nl.dt,nl.mid_id) t1

group by t1.dt1
) dc
join ads_uv_count uv on uv.dt=ua.dt








