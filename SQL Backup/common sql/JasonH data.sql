
select first_time , city, count(*)as cnt
from
(select user_id, date_format(min(session_time),'%Y-%m') as first_time,c.name as city

from appointment_requests ar
join cities c on c.id=ar.city_id
where status ='completed' 

group by user_id) a
where first_time>='2015-10' and first_time<='2016-10'
group by city,first_time

####

select first_time , city, count(*)as cnt
from
(select user_id, date_format(min(session_time),'%Y-%m') as first_time,c.name as city

from appointment_requests ar
join cities c on c.id=ar.city_id
where status ='completed' 

group by user_id) a

join (select user_id,count(*) as cnt 

from appointment_requests

where status='completed' 

group by user_id
having cnt>=2
) r on r.user_id=a.user_id
where first_time>='2015-10' and first_time<='2016-10'
group by city,first_time


####gift

select first_time , city, sum(case when gift_amount is not null and  gift_amount>0 then 1 else 0 end) as gift_card_1st_timer, count(*)  as cnt
from
(select user_id, date_format(min(session_time),'%Y-%m') as first_time,c.name as city,gift_amount

from appointment_requests ar

join cities c on c.id=ar.city_id
where status ='completed' 

group by user_id) a
where first_time>='2015-10' and first_time<='2016-10'
group by city,first_time


####first time

select city,date_format(session_time,'%Y-%m') as date,count(*)
from
(select c.name as city,session_time,case ar.session_time when j.tm then 'FT' else 'Repeat' end as first

from appointment_requests ar
join cities c on c.id=ar.city_id
left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id
where ar.status='completed'
) a
where date_format(session_time,'%Y-%m')>='2015-10' and date_format(session_time,'%Y-%m')<='2016-10' and first='Repeat'
group by city,date




select city,date_format(session_time,'%Y-%m') as date,count(*)
from
(select c.name as city,session_time,case ar.session_time when j.tm then 'FT' else 'Repeat' end as first

from appointment_requests ar
join cities c on c.id=ar.city_id
left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id
where ar.status='completed'
) a
where date_format(session_time,'%Y-%m')>='2015-10' and date_format(session_time,'%Y-%m')<='2016-10' and first='FT'
group by city,date


####
select   date_format(created_at,'%Y-%m') as date,case when signup_type='mobile' THEN 'Mobile App'
	 when signup_type='web' AND 
	 (signed_up_platform IN ('iPad','iPhone', 'Windows') OR signed_up_platform like '%Android%') THEN 'Mobile Web'
	 when signup_type='web' then 'Web' 
   else 'Unknown' END as Type,count(*) as cnt
from 
users u 

where date_format(created_at,'%Y-%m')>='2015-10' and date_format(created_at,'%Y-%m')<='2016-10' and kind='client'

group by date,Type

#####

select kind,count(*) from appointment_requests where status='completed' group by kind
#####

select city,date_format(session_time,'%Y-%m') as date,first,kind, count(*)
from
(select c.name as city,session_time,case ar.session_time when j.tm then 'FT' else 'Repeat' end as first,case when kind in ('rebook','mobile') then 'mobile' else 'web' end as kind

from appointment_requests ar
join cities c on c.id=ar.city_id
left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id
where ar.status='completed'
) a
where date_format(session_time,'%Y-%m')>='2015-10' and date_format(session_time,'%Y-%m')<='2016-10'  
group by city,date,first,kind



