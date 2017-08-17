
### fill rate by region
select  city, sum(case when status='completed' then 1 else 0 end) as completed, sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate,count(*) as requests
from
(select 
 case timezone
 when 'Europe/London' then
date(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as session_local_time,c.name as city,ar.status

from appointment_requests ar
 
join cities c on c.id=ar.city_id

where (ar.status ='completed' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )  and month(session_time)=7 and year(session_time)=2016) a
where session_local_time>='2016-07-23' and session_local_time<='2016-07-24'
group by city

#### fill rate by hour 

select session_local_hour,count(*) as demand, sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate
from
(select 
 case timezone
 when 'Europe/London' then
hour(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
hour(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
hour(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
hour(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
hour(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as session_local_hour,c.name as city,ar.status,

 case timezone
 when 'Europe/London' then
date(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as session_local_time


from appointment_requests ar
 
join cities c on c.id=ar.city_id

where (ar.status ='completed' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )  and month(session_time)=7 and year(session_time)=2016)a
where session_local_time>='2016-07-23' and session_local_time<='2016-07-24'

group by  session_local_hour

## fill rate by rebook
select   sum(case when status='completed' then 1 else 0 end) as completed, sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate,count(*) as cnt_rb
from
(select 
 case timezone
 when 'Europe/London' then
date(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as session_local_time,c.name as city,ar.status,case ar.session_time when j.tm then 'FT' else 'Repeat' end as first

from appointment_requests ar
 
join cities c on c.id=ar.city_id
left join(select user_id, min(session_time) as tm from appointment_requests where status ='completed' or status = 'filled' or status = 'pending' or (status='cancelled' and id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) group by user_id) as j on j.user_id = ar.user_id
where (ar.status ='completed' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )  and month(session_time)=7 and year(session_time)=2016  )a
where session_local_time>='2016-07-23' and session_local_time<='2016-07-24' and first='Repeat'



###fill rate by normal booking
select   sum(case when status='completed' then 1 else 0 end) as completed, sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate,count(*) as cnt_nb
from
(select 
 case timezone
 when 'Europe/London' then
date(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as session_local_time,c.name as city,ar.status,case ar.session_time when j.tm then 'FT' else 'Repeat' end as first

from appointment_requests ar
 
join cities c on c.id=ar.city_id
left join(select user_id, min(session_time) as tm from appointment_requests where status ='completed' or status = 'filled' or status = 'pending' or (status='cancelled' and id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) group by user_id) as j on j.user_id = ar.user_id
where (ar.status ='completed' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )  and month(session_time)=7 and year(session_time)=2016  )a
where session_local_time>='2016-07-23' and session_local_time<='2016-07-24' and first='FT'
 
 

 ####
 
 
 select   sum(case when status='completed' then 1 else 0 end) as completed, sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate,count(*) as cnt_nb
from
(select 
 case timezone
 when 'Europe/London' then
date(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as session_local_time,c.name as city,ar.special_requests,ar.status

from appointment_requests ar
 
join cities c on c.id=ar.city_id
 
where (ar.status ='completed' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )  and month(session_time)=7 and year(session_time)=2016 and kind='rebook' )a
where session_local_time>='2016-07-23' and session_local_time<='2016-07-24'  

 
 ###
  select   sum(case when status='completed' then 1 else 0 end) as completed, sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate,count(*) as cnt_nb
from
(select 
 case timezone
 when 'Europe/London' then
date(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as session_local_time,c.name as city,ar.special_requests,ar.status

from appointment_requests ar
 
join cities c on c.id=ar.city_id
 
where (ar.status ='completed' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )  and month(session_time)=7 and year(session_time)=2016 and kind<>'rebook' )a
where session_local_time>='2016-07-23' and session_local_time<='2016-07-24'  

 
#####

 
select session_local_hour, gender,count(*) as demand, sum(case when status='completed' then 1 else 0 end) as completed,sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate
from
(select 
 case timezone
 when 'Europe/London' then
hour(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
hour(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
hour(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
hour(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
hour(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as session_local_hour,c.name as city,ar.status,

 case timezone
 when 'Europe/London' then
date(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as session_local_time,
case appointment_type
when 'couples' then case when session_gender_double_1=session_gender_double_2 then session_gender_double_1 else 'Either' end
else session_gender_single	end  as gender


from appointment_requests ar
 
join cities c on c.id=ar.city_id

where (ar.status ='completed' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )  and month(session_time)=7 and year(session_time)=2016)a
where session_local_time>='2016-07-23' and session_local_time<='2016-07-24'

group by  session_local_hour,gender
 