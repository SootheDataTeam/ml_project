

##fill rate for special request
select date_format(session_time,'%Y-%m') as date,sum(case when status in ('completed','filled') then 1 else 0 end)/count(*) as fill_rate

from appointment_requests ar

where (ar.status ='completed' or ar.status='filled' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) and ar.id in (select appointment_request_id  from therapist_preferences) and session_time>=last_day(now())+interval 1 day -interval 7 month
group by date

##fill rate for non special request
select date_format(session_time,'%Y-%m') as date,sum(case when status in ('completed','filled') then 1 else 0 end)/count(*) as fill_rate

from appointment_requests ar

where (ar.status ='completed' or ar.status='filled' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) and ar.id not in (select appointment_request_id  from therapist_preferences) and session_time>=last_day(now())+interval 1 day -interval 7 month
group by date


 


