select a.day_local,a.city,a.min_supply as projected_supply,b.mt_engaged as actual_supply,a.productivity as projected_productivity,b.actual_productivity,a.projected_demand,b.actual_demand,b.filled as actual_filled,dayofweek
from
(select r.day_local,r.city,round(cnt/productivity,0) as min_supply,productivity,round(cnt,0) as projected_demand,dayofweek
from
(select day_local,city,sum(case when appointment_type='couples' then 2 else 1 end) /2 as cnt,dayofweek
from
(select 
case timezone
when 'Europe/London' then
weekday(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
weekday(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
weekday(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
weekday(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
weekday(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as dayofweek,appointment_type,
case timezone
when 'Europe/London' then
dayname(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
dayname(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
dayname(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
dayname(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
dayname(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as day_local,
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
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as date_local,
c.name as city,session_time


from appointment_requests ar
join cities c on c.id=ar.city_id
where (ar.status='completed' or ar.status='cancelled' and (ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )) and ar.session_time>=now()-interval 4 week ) a
where  date(date_local)>date(now()-interval dayofweek(now()-interval 1 day) day-interval 3 week)
and date(date_local)<=date(now()-interval dayofweek(now()-interval 1 day) day-interval 1 week)
group by day_local,city)r

join 

(select day_local,city,round(count(*)/count(distinct(therapist_id)),1) as productivity
from
(select 
case timezone
when 'Europe/London' then
weekday(CONVERT_TZ(ar.session_time,'UTC','Europe/London'))
when 'America/Chicago' then
weekday(CONVERT_TZ(ar.session_time,'UTC','America/Chicago'))
when 'America/New_York' then
weekday(CONVERT_TZ(ar.session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
weekday(CONVERT_TZ(ar.session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
weekday(CONVERT_TZ(ar.session_time,'UTC','America/Los_Angeles')) end as dayofweek,
case timezone
when 'Europe/London' then
dayname(CONVERT_TZ(ar.session_time,'UTC','Europe/London'))
when 'America/Chicago' then
dayname(CONVERT_TZ(ar.session_time,'UTC','America/Chicago'))
when 'America/New_York' then
dayname(CONVERT_TZ(ar.session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
dayname(CONVERT_TZ(ar.session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
dayname(CONVERT_TZ(ar.session_time,'UTC','America/Los_Angeles')) end as day_local,
case timezone
when 'Europe/London' then
date(CONVERT_TZ(ar.session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(ar.session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Los_Angeles')) end as date_local,therapist_id,
c.name as city,ar.session_time


from appointment_requests ar
join appointments a on a.appointment_request_id= ar.id
join cities c on c.id=ar.city_id
where a.status in ('complete','reviewed') and ar.session_time>=now()-interval 4 week ) a
where  date(date_local)>date(now()-interval dayofweek(now()-interval 1 day) day-interval 3 week)
and date(date_local)<=date(now()-interval dayofweek(now()-interval 1 day) day-interval 1 week)
group by day_local,city)p on r.day_local=p.day_local and r.city=p.city
order by r.day_local,r.city) a

join(select r.day_local,r.city,mt_engaged,filled, round(filled/mt_engaged,1) as actual_productivity,cnt as actual_demand
from
(select a.day_local,city,count(distinct(therapist_id)) as mt_engaged,count(*) as filled
from
(select 
case timezone
when 'Europe/London' then
dayname(CONVERT_TZ(ar.session_time,'UTC','Europe/London'))
when 'America/Chicago' then
dayname(CONVERT_TZ(ar.session_time,'UTC','America/Chicago'))
when 'America/New_York' then
dayname(CONVERT_TZ(ar.session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
dayname(CONVERT_TZ(ar.session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
dayname(CONVERT_TZ(ar.session_time,'UTC','America/Los_Angeles')) end as day_local,
case timezone
when 'Europe/London' then
date(CONVERT_TZ(ar.session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(ar.session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Los_Angeles')) end as date_local

,therapist_id,c.name as city

from appointment_requests ar
join appointments a on a.appointment_request_id= ar.id
join cities c on c.id=ar.city_id
where a.status in ('complete','reviewed') and ar.session_time>=now()-interval 2 week) a

where date(date_local)>date(now()-interval dayofweek(now()-interval 1 day) day-interval 1 week)
and date(date_local)<=date(now()-interval dayofweek(now()-interval 1 day) day)

group by day_local,city) l

join
(select a.day_local,city,sum(case when appointment_type='couples' then 2 else 1 end) as cnt
from
(select 
case timezone
when 'Europe/London' then
weekday(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
weekday(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
weekday(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
weekday(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
weekday(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as dayofweek,appointment_type,
case timezone
when 'Europe/London' then
dayname(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
dayname(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
dayname(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
dayname(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
dayname(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as day_local,
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
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as date_local,
c.name as city,session_time


from appointment_requests ar
join cities c on c.id=ar.city_id
where (ar.status='completed' or ar.status='cancelled' and (ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )) and ar.session_time>=now()-interval 2 week ) a
where  date(date_local)>date(now()-interval dayofweek(now()-interval 1 day) day-interval 1 week)
and date(date_local)<=date(now()-interval dayofweek(now()-interval 1 day) day)
group by day_local,city)r on l.day_local=r.day_local and l.city=r.city) b on a.day_local=b.day_local and b.city=a.city
 
order by dayofweek