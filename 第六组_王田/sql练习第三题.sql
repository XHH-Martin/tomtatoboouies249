1.create table second_order(`Date` String,Order_id String,User_id String,amount double);

2.--样例数据
同一个用户，相同月份
insert into table second_order values ('2017-01-01','10029028','1000003251',33.57);
insert into table second_order values ('2017-01-01','10029029','1000003251',33.57);
不同用户,相同月份
insert into table second_order values ('2017-01-01','100290288','1000003252',33.57);

insert into table second_order values ('2017-02-02','10029088','1000003251',33.57);
insert into table second_order values ('2017-02-02','100290281','1000003251',33.57);
insert into table second_order values ('2017-02-02','100290282','1000003253',33.57);


insert into table second_order values ('2017-11-02','10290282','100003253',234);



3.需求分析

3.1
先求出订单数和总成交额为result1，然后在算出每个月的用户数result2，然后两个表做join操作，最终求出结果。

select
result1.month,
result1.count_order,
result1.count_amount,
result2.count_user
from 

(select 
    t1.month month,
    count(t1.Order_id) count_order,
    sum(t1.amount) count_amount
from 
(
select 
    date_format(`Date`,'yyyy-MM') month,
    Order_id,
    User_id,
    amount
from second_order
)t1
group by  month
)result1

join 

(select
    t2.month month,
    count(*) count_user
from 
(
    select 
        t1.month month,
        t1.Order_id,
        t1.User_id,
        row_number()  over(partition by t1.month,t1.User_id order by amount) con
    from 
    (

    select 
        date_format(`Date`,'yyyy-MM') month,
        Order_id,
        User_id,
        amount
    from second_order
    )t1
) t2 
where con=1 
group by month
)result2 
on result2.month=result1.month;



3.2安用户id分组，count为1，并且date是在11月份
select
count(*)
from 
(
select 
    Order_id
from 
    second_order 

group by 
Order_id 
having count(*)=1 and max(date_format(`Date`,'yyyy-MM'))='2017-11'
)t1;







