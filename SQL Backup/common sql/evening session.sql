(select  id, concat(first_name," ", last_name) as name,estimated_gender

from users 

where estimated_gender is null and kind='client' and crea)



select count(*) 

from users 

where estimated_gender is null   and kind='client' and id in (select distinct(user_id) from appointment_requests where status='completed' and session_time>=now()-interval 30 day)

#####




######
select count(distinct(user_id))
from
(select user_id,
case timezone
when 'Europe/London' then
hour(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'Australia/Sydney' then
hour(CONVERT_TZ(session_time,'UTC','Australia/Sydney'))
when 'America/Chicago' then
hour(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
hour(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
hour(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
hour(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') ) end as hour_local

from appointment_requests ar


where status='completed' and session_time>=now() -interval 3 month) a

join (select  id

from users 

where  kind='client' and estimated_gender  is null ) u on u.id=a.user_id

where hour_local>=20
####

select sum(case when hour_local>=20 then 1 else 0 end),count(*),sum(case when hour_local>=20 then 1 else 0 end) /count(*) as ratio
from
(select user_id,
case timezone
when 'Europe/London' then
hour(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'Australia/Sydney' then
hour(CONVERT_TZ(session_time,'UTC','Australia/Sydney'))
when 'America/Chicago' then
hour(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
hour(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
hour(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
hour(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') ) end as hour_local

from appointment_requests ar


where status='completed' and session_time>=now() -interval 30 day) a

join (select  id,estimated_gender

from users 

where  kind='client' and estimated_gender ='female') u on u.id=a.user_id
 

####


select id,  name,first_name
from
(select user_id,
case timezone
when 'Europe/London' then
hour(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'Australia/Sydney' then
hour(CONVERT_TZ(session_time,'UTC','Australia/Sydney'))
when 'America/Chicago' then
hour(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
hour(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
hour(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
hour(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') ) end as hour_local

from appointment_requests ar


where status='completed' ) a

join (select  id,concat(u.first_name," ", last_name) as name, first_name

from users u

where  kind='client' and estimated_gender is null ) u on u.id=a.user_id

group by id


 