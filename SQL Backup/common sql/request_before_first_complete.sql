select id,ifnull(request_before_first_complete,0) as request_before_first_complete
from users u
left join
(select ar.user_id,count(*) as request_before_first_complete
from appointment_requests ar
left join (select user_id, min(session_time) as first_booking from appointment_requests where (status='completed' or status='filled') group by user_id) f on f.user_id=ar.user_id
where ar.session_time<first_booking
group by ar.user_id) m on m.user_id=u.id
where kind='client' and appointment_count>0