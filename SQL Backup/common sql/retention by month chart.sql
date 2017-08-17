##### retention% account
###new client
select date_format(first,'%Y-%m') as date,count(*) as new_client
from
(select user_id,min(session_time) as first

from appointment_requests

where status='completed'
group by user_id) a
where year(first)=2017
group by date




#### resurrect and repeat


set @booking_time=''; 

select date,sum(case when resurrect>0 then 1 else 0 end) as resurrect,sum(case when rep>0 then 1 else 0 end) as repeat_client
from
(select date,user_id,sum(case when timestampdiff(day,lst,session_time)>=90 then 1 else 0 end) as resurrect, if(sum(case when timestampdiff(day,lst,session_time)>=90 then 1 else 0 end)>0,0,sum(case when timestampdiff(day,lst,session_time)<90 then 1 else 0 end)) as rep
from
(select date_format(ar.session_time,'%Y-%m') as date,user_id,@booking_time:=ar.session_time as session_time, (select max(session_time) as lst from appointment_requests  where status='completed' and date_format(session_time,'%Y-%m')<date_format(@booking_time,'%Y-%m')   and user_id=ar.user_id)  as lst

 

from appointment_requests ar

where status='completed' and year(session_time)=2017 and is_repeat=1 )a

where lst is not null
group by date, user_id)a
 
group by date


#### repeat component

set @booking_time=''; 

select date,last_booking,count(*) as repeat_bookers_breakdown
from
(select date,user_id,
case when timestampdiff(day,lst,session_time)>=180 then '>180 Days'

when timestampdiff(day,lst,session_time)>=90 and timestampdiff(day,lst,session_time)<180 then '90 to 180 Days'
when timestampdiff(day,lst,session_time)<30 then '< 30 Days'
when timestampdiff(day,lst,session_time)>=30 and timestampdiff(day,lst,session_time)<60 then '30 to 60 Days'
when timestampdiff(day,lst,session_time)>=60 and timestampdiff(day,lst,session_time)<90 then '60 to 90 Days' end as last_booking

from
(select date_format(ar.session_time,'%Y-%m') as date,user_id,@booking_time:=ar.session_time as session_time, (select max(session_time) as lst from appointment_requests  where status='completed' and date_format(session_time,'%Y-%m')<date_format(@booking_time,'%Y-%m')   and user_id=ar.user_id)  as lst

 

from appointment_requests ar

where status='completed' and year(session_time)=2017 and is_repeat=1 )a

where lst is not null
group by date, user_id)a
 
group by date,last_booking
order by date,field(last_booking,'< 30 Days','30 to 60 Days','60 to 90 Days','90 to 180 Days','>180 Days')

