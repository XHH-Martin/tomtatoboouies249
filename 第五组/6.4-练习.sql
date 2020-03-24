create table user_level_repurchase(
`user_level` string,
 `sku_id` string,
 `AtLeastOnce` bigint,
 `AtLeastTwice` bigint,
 `Repurchase_rate` decimal(10,2),
 `rank` int
)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/user_level_purchase/'



--求每个等级的用户 对应的复购率前十的商品排行。


--   用户等级                   商品排行


--1、最终一定是每个用户等级 显示十条数据，每条数据里包含 不同 的商品信息、复购率、排行，

--2、排行 ：每个用户等级内部 按复购率排行，所以要开窗口，窗口内部 按用户等级分区 ，区内按复购率排序

--3、复购率： 购买该商品次数至少1次的人数 / 购买该商品次数至少两次的人数

--4、所以要求出  每个用户 针对每件商品的 购买次数。---->>用户购买商品明细表。




--4、每个用户 针对每件商品的 购买次数。
(
select
    sdd.user_level user_level,
    sdd.user_id user_id,
    sdd.sku_id sku_id,
    sum(sdd.order_count) order_count --用户对单一商品总购买次数  在一个月内
from 
    dws_sale_detail_daycount sdd
where 
    date_format('2019-02-10','yyyy-MM')=date_format(dt,'yyyy-MM')
group by 
    sdd.user_level,
    sdd.user_id,
    sdd.sku_id
) table1

--3、 复购率： 购买该商品次数至少1次的人数 / 购买该商品次数至少两次的人数
(
select 
    user_level,
    sku_id,
    sum(if(order_count>=1,1,0)) AtLeastOnce,
    sum(if(order_count>=2,1,0)) AtLeastTwice,
    --复购率： 重复购买多次的人数 与 至少购买了一次的人数  的比率。
    sum(if(order_count>=2,1,0))/sum(if(order_count>=1,1,0)) Repurchase_rate
from
    table1
group by
    user_level,
    sku_id
)table2

-- 2、对商品进行排名，按复购率   
(
select
    sku_id,
    user_level,
    AtLeastOnce,
    AtLeastTwice,
    Repurchase_rate,
    rank() over(partition user_level order by Repurchase_rate desc) rank
from
    table2
)table3
    
    
-- 1、挑选排行前十的
select
    sku_id,
    user_level,
    AtLeastOnce,
    AtLeastTwice,
    Repurchase_rate,
    rank
from
    table3
where 
    rank <=10;
    
    

------------------=========================-------------------------------   
select
    t3.user_level,
    t3.sku_id,
    t3.AtLeastOnce,
    t3.AtLeastTwice,
    t3.Repurchase_rate,
    t3.rank
from
(
    select
        t2.sku_id sku_id,
        t2.user_level user_level,
        t2.AtLeastOnce AtLeastOnce,
        t2.AtLeastTwice AtLeastTwice,
        t2.Repurchase_rate Repurchase_rate,
        rank() over(partition by t2.user_level order by t2.Repurchase_rate desc) rank  --也可以用row_number() hanshu
    from
    (
        select 
            t1.user_level user_level,
            t1.sku_id sku_id,
            sum(if(order_count>=1,1,0)) AtLeastOnce,
            sum(if(order_count>=2,1,0)) AtLeastTwice,
            --3、复购率： 重复购买多次的人数 与 至少购买了一次的人数  的比率。
            sum(if(order_count>=2,1,0))/sum(if(order_count>=1,1,0)) Repurchase_rate
        from
        (
            select
                sdd.user_level user_level,
                sdd.user_id user_id,
                sdd.sku_id sku_id,
                sum(sdd.order_count) order_count --用户对单一商品总购买次数 在当前月内。
            from 
                dws_sale_detail_daycount sdd
            where 
                date_format('2019-02-10','yyyy-MM')=date_format(dt,'yyyy-MM')
            group by 
                sdd.user_level,
                sdd.user_id,
                sdd.sku_id
        )t1
        group by
            t1.user_level,
            t1.sku_id
        )t2
    
) t3
where 
    rank <=10 ;
