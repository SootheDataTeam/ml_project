
###query for acceptance ratio
select a.id, concat(u.first_name,' ', u.last_name),booking_type,ifnull(sum(case when a.status='accepted' then 1 else 0 end)/count(*),0) as acceptance_rate
from 
(select f.therapist_id as id, f.status,  case when TIMESTAMPDIFF(hour,f.updated_at,ar.session_time)<=5 then 'OnDemand' else 'PreBooking' end as booking_type
from appointment_offers f 
join appointment_requests ar
on ar.id=f.request_id
where ar.session_time>=last_day(now()) + interval 1 day - interval 3 month
and (f.status='accepted' or f.status='rejected' or f.status='terminated')
and f.created_at > (now() - interval 45 day)) a

join users u on u.id=a.id
group by a.id, booking_type
order by booking_type,acceptance_rate desc
