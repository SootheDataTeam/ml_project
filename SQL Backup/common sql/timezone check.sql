select timezone from appointment_requests where city_id=16 and timezone='Pacific Time (US & Canada)'


select * from cities 

select c.name,count(*) as cnt

from appointment_requests ar
join cities c on c.id=ar.city_id 
where timezone='Pacific Time (US & Canada)' 
group by c.name

order by cnt desc


####
select timezone,count(*) as cnt

from appointment_requests ar
where status in (ar.status ='completed' or ar.status='filled' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )

group by timezone

order by cnt desc









