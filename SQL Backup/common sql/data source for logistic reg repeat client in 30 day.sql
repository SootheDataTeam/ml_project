
select sl.*,
case 
    when completed_sessions=1 then 'First Timer'
    when completed_sessions>=2 and completed_sessions<=5 then 'Repeat Customer'
    when  completed_sessions>=6 and completed_sessions<=10 then 'Valued Customer'
    else 'Highly Valued Customer' end as type

,re.rep
from
(select user_id,sum(case when session_length=60 then 1 else 0 end)/count(*) as sixtymin_session_ratio,sum(case when session_length=90 then 1 else 0 end)/count(*) as nintymin_session_ratio,sum(case when session_length=120 then 1 else 0 end)/count(*) as twohour_session_ratio
,sum(case when id in (select appointment_request_id  from therapist_preferences) then 1 else 0 end)/count(*) as special_requests_ratio,sum(case when credit_amount>0 then 1 else 0 end)/count(*) as credit_ratio,count(*) as completed_sessions


from appointment_requests
where status='completed'
group by user_id
having completed_sessions>1) sl

 

join
(select user_id,  case when u.completed_sessions>1 then 1 else 0 end as rep 
from
(select ar.user_id,first,count(*) as completed_sessions
from
(select user_id,min(session_time) as first,city_id
 from appointment_requests
where status='completed' 
group by user_id) ar
join 
(select user_id,session_time  from appointment_requests where status='completed' ) u on u.user_id=ar.user_id
where timestampdiff(month,ar.first,u.session_time)=0
group by user_id
) u) re on re.user_id=sl.user_id



