--                                  用户行为漏斗分析

--1、需求分析
--        对用户行为做漏斗分析
        
--        访问网站                  
        
--         下单                     
        
--         支付                     

                                


--        单日 下单的人数 / 访问人数     访问到下单的转换率
--        单日 支付人数   / 下单人数     下单到支付的转换率

--单日访问人数
--    日周月活表中直接拿到
--单日下单人数
--    用户行为宽表中对下单次数>0的user_id进行统计
--支付人数
--    用户行为宽表中对支付次数>0的user_id进行统计
    
    
--需要使用到的表

--        日周月活表
--        用户行为宽表


--漏斗分析表   课件上
drop table if exists ads_user_action_convert_day;
create external  table ads_user_action_convert_day(
    `dt` string COMMENT '统计日期',
    `total_visitor_m_count`  bigint COMMENT '总访问人数',
    `order_u_count` bigint     COMMENT '下单人数',
    `visitor2order_convert_ratio`  decimal(10,2) COMMENT '访问到下单转化率',
    `payment_u_count` bigint     COMMENT '支付人数',
    `order2payment_convert_ratio` decimal(10,2) COMMENT '下单到支付的转化率'
 ) COMMENT '用户行为漏斗分析'
row format delimited  fields terminated by '\t'
location '/warehouse/gmall/ads/ads_user_action_convert_day/'
;


--用户行为宽表
drop table if exists dws_user_action;
create external table dws_user_action 
(   
    user_id          string      comment '用户 id',
    order_count     bigint      comment '下单次数 ',
    order_amount    decimal(16,2)  comment '下单金额 ',
    payment_count   bigint      comment '支付次数',
    payment_amount  decimal(16,2) comment '支付金额 ',
    comment_count   bigint      comment '评论次数'
) COMMENT '每日用户行为宽表'
PARTITIONED BY (`dt` string)
stored as parquet
location '/warehouse/gmall/dws/dws_user_action/'
tblproperties ("parquet.compression"="snappy");



--日周月活表
drop table if exists ads_uv_count;
create external table ads_uv_count( 
    `dt` string COMMENT '统计日期',
    `day_count` bigint COMMENT '当日用户数量',
    `wk_count`  bigint COMMENT '当周用户数量',
    `mn_count`  bigint COMMENT '当月用户数量',
    `is_weekend` string COMMENT 'Y,N是否是周末,用于得到本周最终结果',
    `is_monthend` string COMMENT 'Y,N是否是月末,用于得到本月最终结果' 
) COMMENT '活跃设备数'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_uv_count/';



--商品详情页表

drop table if exists dwd_newsdetail_log;
CREATE EXTERNAL TABLE dwd_newsdetail_log(
`mid_id` string,
`user_id` string, 
...
`server_time` string)
PARTITIONED BY (dt string)
location '/warehouse/gmall/dwd/dwd_newsdetail_log/';


--拓展


--1、需求分析
--                             对用户行为做漏斗分析
        
--        访问网站  
          
--        到达订单详情页          
        
--         下单                     
        
--         支付                     

                                

--        单日  到达详情页人数 / 访问人数           访问-到达详情页的转换率
--        单日 下单的人数      / 到达详情页人数     到达详情页-下单的转换率
--        单日 支付人数        / 下单人数           下单-支付的转换率

--单日访问人数
--    日周月活表中直接拿到


--单日到达订单详情页人数
--     用户行为仓库中dwd_newsdetail_log 
--     先分日期对user_id进行去重 
--     然后对单日的user_id进行统计


--单日下单人数
--    用户行为宽表中对下单次数>0的user_id进行统计


--支付人数

--    用户行为宽表中对支付次数>0的user_id进行统计
    
    
--需要使用到的表

--        日周月活表
--        用户行为宽表
--        用户行为仓库中dwd_newsdetail_log



drop table if exists ads_user_action_convert_day_2;
create external  table ads_user_action_convert_day_2(
    `dt` string COMMENT '统计日期',
    `total_visitor_m_count`  bigint COMMENT '总访问人数',
    `detail_u_count` bigint comment '到达商品详情页人数',
    `visitor2detail_convert_ratio`  decimal(10,2) COMMENT '访问到详情转化率',
    `order_u_count` bigint     COMMENT '下单人数',
    `detail2order_convert_ratio`  decimal(10,2) COMMENT '详情到下单转化率',
    `payment_u_count` bigint     COMMENT '支付人数',
    `order2payment_convert_ratio` decimal(10,2) COMMENT '下单到支付的转化率'
 ) COMMENT '用户行为漏斗分析'
row format delimited  fields terminated by '\t'
location '/warehouse/gmall/ads/ads_user_action_convert_day_2/'
;



--疑问 日周月活表以设备ID定义为1个用户 用户行为宽表以user_id 定义一个用户



























