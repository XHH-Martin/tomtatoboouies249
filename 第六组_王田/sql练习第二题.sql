create table Second_Visit (user_id string,shop string);

insert into table second_visit values ('1','a');
insert into table second_visit values ('1','b');
insert into table second_visit values ('2','a');
insert into table second_visit values ('3','c');
insert into table second_visit values ('1','a');
insert into table second_visit values ('1','a');




1.每个店铺的UV（访客数）
select 
    t1.shop,
    count(*)
from 
(
    select 
        user_id,
        shop
    from second_visit 
    group by user_id,shop
)t1 
group by shop;

2.每个店铺访问次数top3的访客信息，输出店铺名称，访客id，访问次数
select 
    t2.shop,
    t2.user_id,
    t2.num
from 
(
    select 
        t1.user_id user_id,
        t1.shop shop,
        t1.num,
        rank () over (partition by t1.user_id order by num) con
    from 
    (
        select 
            user_id,
            shop,
            count(*) num
        from second_visit 
        group by user_id,shop
    )t1
)t2 
where con<=3;






