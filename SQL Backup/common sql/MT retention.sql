



(select group_ABC,date_format(now()-interval 5 month,'%Y-%m') as date ,count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 5 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 5 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') and therapist_id in (select m.therapist_id
from (select DATE_FORMAT(ap.session_time,'%Y-%m') as date,ap.therapist_id

from appointments ap

where   (ap.status = 'complete' or ap.status = 'reviewed') and DATE_FORMAT(ap.session_time,'%Y-%m')=DATE_FORMAT(now()-interval 5 month,'%Y-%m')

group by date,ap.therapist_id) m)


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 4 month,'%Y-%m') as date ,count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 4 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 4 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') and therapist_id in (select m.therapist_id
from (select DATE_FORMAT(ap.session_time,'%Y-%m') as date,ap.therapist_id

from appointments ap

where   (ap.status = 'complete' or ap.status = 'reviewed') and DATE_FORMAT(ap.session_time,'%Y-%m')=DATE_FORMAT(now()-interval 4 month,'%Y-%m')

group by date,ap.therapist_id) m)


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 3 month,'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 3 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 3 month)+ interval 1 day and  (a.status='complete' or a.status='reviewed') and therapist_id in (select m.therapist_id
from (select DATE_FORMAT(ap.session_time,'%Y-%m') as date,ap.therapist_id

from appointments ap

where (ap.status = 'complete' or ap.status = 'reviewed') and DATE_FORMAT(ap.session_time,'%Y-%m')=DATE_FORMAT(now()-interval 3 month,'%Y-%m')

group by date,ap.therapist_id) m)


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 2 month,'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 2 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 2 month)+ interval 1 day and  (a.status='complete' or a.status='reviewed') and therapist_id in (select m.therapist_id
from (select DATE_FORMAT(ap.session_time,'%Y-%m') as date,ap.therapist_id

from appointments ap

where (ap.status = 'complete' or ap.status = 'reviewed') and DATE_FORMAT(ap.session_time,'%Y-%m')=DATE_FORMAT(now()-interval 2 month,'%Y-%m')

group by date,ap.therapist_id) m)


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 1 month,'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 1 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 1 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') and therapist_id in (select m.therapist_id
from (select DATE_FORMAT(ap.session_time,'%Y-%m') as date,ap.therapist_id

from appointments ap

where (ap.status = 'complete' or ap.status = 'reviewed') and DATE_FORMAT(ap.session_time,'%Y-%m')=DATE_FORMAT(now()-interval 1 month,'%Y-%m')

group by date,ap.therapist_id) m)



group by therapist_id) f

group by group_ABC)

#### available
(select group_ABC,date_format(now()-interval 5 month,'%Y-%m') as date ,count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then  'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 5 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 5 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 4 month,'%Y-%m') as date ,count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then  'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 4 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 4 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 3 month,'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then  'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 3 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 3 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 2 month,'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then  'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 2 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 2 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 1 month,'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then  'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 1 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 1 month)+ interval 1 day  and (a.status='complete' or a.status='reviewed') 



group by therapist_id) f

group by group_ABC)

##

 
 select date,type,count(*) as MT
from   
 (select   
   
   therapist_id,date,case 
    when cnt<=6 then 'C'
    when cnt> 6 and cnt<=20 then 'B'
    when  cnt>20 then 'A'
  end as type

from
(select therapist_id ,date_format(session_time,'%Y-%m') as date,count(*) cnt
from appointments a

where status in ('complete','reviewed') and session_time>= last_day(now())+ interval 1 day-interval 7 month and a.session_time<last_day(now())+ interval 1 day -interval 1 month
group by therapist_id)a) b 

group by date,type
