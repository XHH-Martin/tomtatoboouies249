
1.建表语句
create table first(userid string,visitDate String,visitCount string);

2.插入数据

insert into table first values('u01','2017/1/21','5');
insert into table first values('u02','2017/1/23','6');
insert into table first values('u03','2017/1/22','8');
insert into table first values('u04','2017/1/20','3');
insert into table first values('u01','2017/1/23','6');
insert into table first values('u01','2017/2/21','8');
insert into table first values('u02','2017/1/23','6');
insert into table first values('u01','2017/2/22','4');

3.转变时间格式

select from_unixtime(unix_timestamp(visitDate,'yyyy/mm/dd'),'yyyy-mm') ;

4.需求分析
    首先按照月份分组，算出每个月的总访问次数
    然后用窗口函数，按照月份计算累加访问次数

4.1格式化时间
select 
    userId,
    from_unixtime(unix_timestamp(visitDate,'yyyy/mm/dd'),'yyyy-mm') month,
    visitCount
from first;               --------t1表

4.2求月份的总次数
select 
    userId,
    month,
    sum(visitCount) sum_month
from t1 
group by month;               ---------t2表      

4.3按照用户id开窗，按时间排序
select 
    userId,
    month,
    sum_month,
    sum(sum_month) over (partition by userID order by month rows between UNBOUNDED PRECEDING and current row) sum_all
from t2


5.终极sql

select 
    t2.userId,
    t2.month,
    sum_month,
    sum(t2.sum_month) over (partition by userId order by month rows between UNBOUNDED PRECEDING and current row) sum_all
from 
(
    select 
        t1.userId userId,
        t1.month month,
        sum(t1.visitCount) sum_month
    from 
    (
        select 
            userId,
            from_unixtime(unix_timestamp(visitDate,'yyyy/mm/dd'),'yyyy-mm') month,
            visitCount
        from first
    ) t1            
    group by  userId,month
)t2;


