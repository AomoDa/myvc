
create EXTERNAL table tkdm_data_block_device_day(
deviceid string,
cid int )
PARTITIONED BY (ds string)
clustered by (deviceid) sorted by(deviceid)  into 2 buckets
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
STORED AS ORC
location 's3://reyuntkio/warehouse/track/track_mid.db/tkdm_data_block_device_day'
;



insert overwrite table track_mid.tkdm_data_block_device_day partition(ds='2017-05-22')

select deviceid,
       cid
   from (
    select deviceid,
       cid,
       count(1) over(partition by deviceid,cid ) as num_clk_day,
       to_unix_timestamp(clicktime) - lag(to_unix_timestamp(clicktime),2) over( 
               partition by deviceid,cid order by to_unix_timestamp(clicktime))  as time_three
   from trackinitiate.todayclick_bucket
   where ds='2017-05-22' and 
         deviceid not like '%.%'  
         and cid!='unknown' and 
         deviceid  not in ('00000000-0000-0000-0000-000000000000','0','00000000','00000000000000')
    ) as t
    where num_clk_day >=5 or time_three <=5
    group by deviceid,cid

union 

select b.deviceid as deviceid,
       b.cid as cid
  from 
      (select deviceid,
              cid,
              count(distinct if(ds='2017-05-22',appid,null)) num_ins_app_day,
              count(distinct appid) as num_ins_app_week
         from trackinitiate.todayinstallchannel_bucket
         where ds between date_sub('2017-05-22',6) and '2017-05-22' and 
               cid!='unknown'  and channelid!='_default_' and 
               deviceid  not in ('00000000-0000-0000-0000-000000000000','0','00000000','00000000000000')
         group by deviceid,cid
         having max(ds)='2017-05-22' 
        ) as b 

      left join

      (select deviceid,
              cid
         from trackconceptions.dau_bucket
         where ds =date_add('2017-05-22',1) and 
                channelid!='_default_' and 
               cid!='unknown' and 
               deviceid !='00000000-0000-0000-0000-000000000000'
          group by deviceid,cid
       ) as c  on b.deviceid=c.deviceid and b.cid=c.cid
    where (b.num_ins_app_day >=3) or (b.num_ins_app_week >3 and c.cid is null )


-----------------


create EXTERNAL table tkdm_data_cid_summ_day(
cid int,
num_clk_day bigint,
num_ins_day bigint )
PARTITIONED BY (ds string)
clustered by (cid) sorted by(cid)  into 1 buckets
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
STORED AS ORC
location 's3://reyuntkio/warehouse/track/track_mid.db/tkdm_data_cid_summ_day'
;


insert overwrite table track_mid.tkdm_data_cid_summ_day partition(ds='2017-05-22')
select a.cid,
       a.num_clk_day,
       nvl(b.num_ins_day,0)  as num_ins_day
from 
   (select cid,
          count(1) num_clk_day
   from trackinitiate.todayclick_bucket
   where ds='2017-05-22'
         and cid!='unknown' 
    group by cid
    ) as a

 left join 

  (select cid,
         count(1) as num_ins_day
  from trackinitiate.todayinstallchannel_bucket
  where ds ='2017-05-22' and 
        cid!='unknown'  and channelid!='_default_'
  group by cid
   ) as b on a.cid=b.cid


-----------------


create EXTERNAL table tkdm_base_block_device_info(
deviceid string,
cid int,
is_block int,
first_into_ds string,
last_into_ds string,
last_out_ds string
)
PARTITIONED BY (ds string)
clustered by (deviceid) sorted by(deviceid)  into 8 buckets
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
STORED AS ORC
location 's3://reyuntkio/warehouse/track/track_mid.db/tkdm_base_block_device_info'
;


--set hive.auto.convert.sortmerge.join=true;
--set hive.optimize.bucketmapjoin=true;
--set hive.optimize.bucketmapjoin.sortedmerge=true;

insert overwrite table track_mid.tkdm_base_block_device_info partition(ds='2017-05-22')

select nvl(a.deviceid,b.deviceid) as deviceid,
       nvl(a.cid,b.cid) as cid,
       case when b.deviceid is not null then 1
            when c.deviceid is not null then 0
            else a.is_block end as is_block,
       nvl(a.first_into_ds,'2017-05-22') as first_into_ds,
       if(isnotnull(b.deviceid),'2017-05-22',a.last_into_ds) as last_into_ds,
       if(isnotnull(c.deviceid) and isnull(b.deviceid) and a.is_block=1 ,'2017-05-22',a.last_out_ds) as last_out_ds
from 
 (select deviceid,
         cid,
         is_block,
         first_into_ds,
         last_into_ds,
         last_out_ds
    from track_mid.tkdm_base_block_device_info
    where ds =date_sub('2017-05-22',1) and 
    deviceid !='00000000-0000-0000-0000-000000000000'
   ) as a 

full join

  (select deviceid,
          cid
     from track_mid.tkdm_data_block_device_day
     where ds='2017-05-22' and 
           deviceid !='00000000-0000-0000-0000-000000000000'
   ) as b on a.deviceid=b.deviceid and a.cid=b.cid

left join

   (select deviceid,
          cid
    from trackconceptions.payment_bucket
    where ds='2017-05-22' and 
          cid!='unknown'  and 
          channelid!='_default_' and 
          deviceid !='00000000-0000-0000-0000-000000000000'
    group by deviceid,cid
   ) as c on a.deviceid=c.deviceid and a.cid=c.cid



----------------



create EXTERNAL table tkdm_data_block_ip_day(
ip string,
cid int )
PARTITIONED BY (ds string)
clustered by (ip) sorted by(ip)  into 2 buckets
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
STORED AS ORC
location 's3://reyuntkio/warehouse/track/track_mid.db/tkdm_data_block_ip_day'
;


insert overwrite table track_mid.tkdm_data_block_ip_day partition(ds='2017-05-22')

select ip,
       cid
   from trackinitiate.todayclick_bucket
   where ds='2017-05-22' and 
         cid!='unknown' and 
         ip!='unknown'
   group by ip,cid
   having count(1)>=50

union 

select ip,
       cid
   from 
    (select aa.ip as ip,
           aa.cid as cid,
           (sum(aa.n)) / (count(distinct if(aa.ds='2017-05-22',aa.deviceid,null))),
           count(distinct aa.appid)
    from 
    (select appid,
            deviceid,
            cid,
            ip,
            ds,
            count(if(ds='2016-05-21',1,null)) n 
        from trackinitiate.todayinstallchannel_bucket
        where ds between date_sub('2017-05-22',6) and '2017-05-22' and 
              cid!='unknown'  and channelid!='_default_' and ip !='unknown'
        group by appid,deviceid,cid,ip,ds
    ) as aa

    left join

    (select appid,
            cid,
            deviceid
        from trackconceptions.dau_bucket
        where ds=date_add('2017-05-22',1) and 
              channelid!='_default_' and 
              cid!='unknown'
        group by appid,cid,deviceid
    ) as bb  on aa.appid=bb.appid and aa.deviceid=bb.deviceid and aa.cid=bb.cid
    group by aa.ip,aa.cid
    having  max(aa.ds)='2017-05-22' and 
           ( (sum(aa.n) >10) or 
           ( (sum(aa.n)) / (count(distinct if(aa.ds='2017-05-22',aa.deviceid,null))) >=2) 
           or(count(distinct aa.appid) >=5 and count(bb.deviceid)=0))
    ) as x1




create EXTERNAL table tkdm_data_out_ip_day(
ip string,
cid int,
out_value double )
PARTITIONED BY (ds string)
clustered by (ip) sorted by(ip)  into 2 buckets
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
STORED AS ORC
location 's3://reyuntkio/warehouse/track/track_mid.db/tkdm_data_out_ip_day'
;


insert overwrite table track_mid.tkdm_data_out_ip_day partition(ds='2017-05-22')
select b.ip,
       b.cid,
       round(sum(a.pay_times) / count(distinct if(b.is_last_week=1,b.appid,null)),4) as out_value
from 
(select appid,
       cid,
       deviceid,
       sum(times) as pay_times
    from trackconceptions.payment_bucket
    where ds between date_sub('2017-05-22',6) and '2017-05-22' and  
          cid!='unknown'  and 
          channelid!='_default_' 
    group by appid,cid,deviceid
) as a 

join

(select appid,
        cid,
        deviceid,
        ip,
        if(to_date(installdate) between date_sub('2017-05-22',6) and '2017-05-22' ,1,0) as is_last_week
    from trackinitiate.installchannel_bucket
    where ds ='2017-05-22' and 
          cid!='unknown'  and 
          channelid!='_default_' 
) as b on a.appid=b.appid and a.cid=b.cid and a.deviceid=b.deviceid
group by b.ip,b.cid
having round(sum(a.pay_times) / count(distinct if(b.is_last_week=1,b.appid,null)),4) >0.01




 
create EXTERNAL table tkdm_base_block_ip_info(
ip string,
cid int,
is_block int,
first_into_ds string,
last_into_ds string,
last_out_ds string
)
PARTITIONED BY (ds string)
clustered by (ip) sorted by(ip)  into 8 buckets
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
STORED AS ORC
location 's3://reyuntkio/warehouse/track/track_mid.db/tkdm_base_block_ip_info'
;


insert overwrite table track_mid.tkdm_base_block_ip_info partition(ds='2017-05-22')
select nvl(a.ip,b.ip) as ip,
       nvl(a.cid,b.cid) as cid,
       case when b.ip is not null then 1
            when c.ip is not null then 0
            else a.is_block end as is_block,
       nvl(a.first_into_ds,'2017-05-22') as first_into_ds,
       if(isnotnull(b.ip),'2017-05-22',a.last_into_ds) as last_into_ds,
       if(isnotnull(c.ip) and isnull(b.ip) and a.is_block=1 ,'2017-05-22',a.last_out_ds) as last_out_ds
from 
 (select ip,
         cid,
         is_block,
         first_into_ds,
         last_into_ds,
         last_out_ds
    from track_mid.tkdm_base_block_ip_info
    where ds =date_sub('2017-05-22',1) and 
    ip !='00000000-0000-0000-0000-000000000000'
   ) as a 

full join

  (select ip,
          cid
     from track_mid.tkdm_data_block_ip_day
     where ds='2017-05-22'
   ) as b on a.ip=b.ip and a.cid=b.cid

left join

   (select ip,
          cid
    from track_mid.tkdm_data_out_ip_day
    where ds='2017-05-22'
   ) as c on a.ip=c.ip and a.cid=c.cid




-----------------
--click
-----------------

create EXTERNAL table tkdm_rlt_clk_device_day(
deviceid string,
cid int,
is_block_cid int,
is_in_list_all_did int,
is_in_list_cid_did int,
is_normal_did int,
is_in_list_all_ip int,
is_in_list_cid_ip int,
is_normal_ip int,
old_is_normal int
)
PARTITIONED BY (ds string)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
STORED AS ORC
location 's3://reyuntkio/warehouse/track/track_mid.db/tkdm_rlt_clk_device_day'
;


insert overwrite table track_mid.tkdm_rlt_clk_device_day partition(ds='2017-05-22')
select /*+mapjoin(b)*/ a.deviceid,
       a.cid,
       if(isnotnull(b.cid),1,0) as is_block_cid,
       if(isnotnull(c.list) and a.is_did=1 ,1,0) as is_in_list_all_did,
       if( isnotnull(c.list) and find_in_set(cast(a.cid as string),c.list)!=0 and a.is_did=1 ,1,0 ) as is_in_list_cid_did,
       case when isnull(c.list) and a.is_did=1  then 1
            when isnotnull(b.cid) and a.is_did=1 then 0
            when find_in_set(cast(a.cid as string),c.list)!=0 and a.is_did=1 then 0
            else 1 end as is_normal_did,
        if(isnotnull(d.list),1,0) as is_in_list_all_ip,
        if(isnotnull(d.list) and find_in_set(cast(a.cid as string),d.list)!=0,1,0 ) as is_in_list_cid_ip,
        case when isnull(d.list) then 1
             when isnotnull(b.cid)  then 0
             when find_in_set(cast(a.cid as string),d.list)!=0 then 0
             else 1 end as is_normal_ip,        
        a.old_is_normal
from 
    (select deviceid,
            cid,
            is_normal as old_is_normal,
            if(deviceid not like '%.%',1,0) as is_did,
            ip
       from trackinitiate.todayclick_bucket
       where ds='2017-05-22' 
             and cid!='unknown' and 
             deviceid  not in ('00000000-0000-0000-0000-000000000000','0','00000000','00000000000000')
    ) as a 

    left join 

    (select cid
       from track_mid.tkdm_data_cid_summ_day
       where ds between date_sub('2017-05-22',3) and date_sub('2017-05-22',1)
       group by cid
       having sum(num_clk_day) >=10000 and 
              sum(num_ins_day)/sum(num_clk_day) <=0.00014
    ) as b  on a.cid=b.cid

 left join 

(select deviceid,
        concat_ws(',',collect_list(cast(cid as string))) as list
   from track_mid.tkdm_base_block_device_info
   where ds= date_sub('2017-05-22',1) 
         and is_block=1
   group by deviceid
) as c on a.deviceid=c.deviceid and a.is_did=1


left join

(select ip,
        concat_ws(',',collect_list(cast(cid as string))) as list
    from track_mid.tkdm_base_block_ip_info
    where ds= date_sub('2017-05-22',1) 
         and is_block=1
    group by ip
) as d on a.ip=d.ip




-----------------
--install
-----------------

create EXTERNAL table tkdm_rlt_ins_device_day(
deviceid string,
cid int,
is_block_cid int,
is_in_list_all_did int,
is_in_list_cid_did int,
is_normal_did int,
is_in_list_all_ip int,
is_in_list_cid_ip int,
is_normal_ip int,
old_is_normal int
)
PARTITIONED BY (ds string)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
STORED AS ORC
location 's3://reyuntkio/warehouse/track/track_mid.db/tkdm_rlt_ins_device_day'
;


insert overwrite table track_mid.tkdm_rlt_ins_device_day partition(ds='2017-05-22')
select /*+mapjoin(b)*/ a.deviceid,
       a.cid,
       if(isnotnull(b.cid),1,0) as is_block_cid,
       if(isnotnull(c.list),1,0) as is_in_list_all_did ,
       if(isnotnull(c.list) and find_in_set(cast(a.cid as string),c.list)!=0,1,0 ) as is_in_list_cid_did ,
       case when isnull(c.list) then 1
            when isnotnull(b.cid)  then 0
            when find_in_set(cast(a.cid as string),c.list)!=0 then 0
            else 1 end as is_normal_did ,
        if(isnotnull(d.list),1,0) as is_in_list_all_ip,
        if(isnotnull(d.list) and find_in_set(cast(a.cid as string),d.list)!=0,1,0 ) as is_in_list_cid_ip,
        case when isnull(d.list) then 1
             when isnotnull(b.cid)  then 0
             when find_in_set(cast(a.cid as string),d.list)!=0 then 0
             else 1 end as is_normal_ip,            
        a.old_is_normal
from 
    (select deviceid,
            cid,
            is_normal as old_is_normal,
            ip
       from trackinitiate.todayinstallchannel_bucket
       where ds='2017-05-22'
             and cid!='unknown' and 
             deviceid  not in ('00000000-0000-0000-0000-000000000000','0','00000000','00000000000000')
    ) as a 

    left join 

    (select cid
       from track_mid.tkdm_data_cid_summ_day
       where ds between date_sub('2017-05-22',3) and date_sub('2017-05-22',1)
       group by cid
       having sum(num_clk_day) >=10000 and 
              sum(num_ins_day)/sum(num_clk_day) <=0.00014
    ) as b  on a.cid=b.cid

 left join 

(select deviceid,
       concat_ws(',',collect_list(cast(cid as string))) as list
   from track_mid.tkdm_base_block_device_info
   where ds= date_sub('2017-05-22',1) 
         and is_block=1
   group by deviceid
) as c on a.deviceid=c.deviceid

left join

(select ip,
        concat_ws(',',collect_list(cast(cid as string))) as list
    from track_mid.tkdm_base_block_ip_info
    where ds= date_sub('2017-05-22',1) 
         and is_block=1
    group by ip
) as d on a.ip=d.ip



