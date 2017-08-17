select f.therapist_id as ID,u.name,ifnull(round(sum(case when f.status='accepted' then 1 else 0 end)/count(*),2),0) as acceptance_rate,f.hour_booked_ahead,
case hour_booked_ahead
when 1 then 'Within 1 Hour'
when 2 then '1 Hour Ahead'
when 3 then '2 Hours Ahead'
when 4 then '2 to 5 Hours Ahead'
when 5 then '5 to 10 Hours Ahead'
when 6 then '10 to 24 Hours Ahead'
when 7 then '1 to 2 Days Ahead'
when 8 then 'More than 2 Days Ahead'
end as Booking_hour


from
(select ar.id,of.status,of.therapist_id,
case 
when TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)=0  then 1
when TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)=1 then 2
when TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)=2 then 3
when TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)>2 and TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)<=5 then 4
when TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)>5 and TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)<=10 then 5
when TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)>10 and TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)<=24 then 6
when TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)>24 and TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)<=48 then 7
else 8
end
as hour_booked_ahead

from appointment_offers of 
join (select id,session_time from appointment_requests where session_time>=last_day(now())+ interval 1 day - interval 12 month) ar on ar.id=of.request_id
where (status='accepted' or status='rejected' or status='terminated')

 ) f
join (select id, concat(first_name,' ', last_name) as name from users where kind='therapist' )u on u.id=f.therapist_id
group by f.therapist_id,f.hour_booked_ahead
order by f.therapist_id,f.hour_booked_ahead

###modified


select f.therapist_id as ID,u.name,ifnull(sum(case when f.status='accepted' then 1 else 0 end)/count(*),0) as acceptance_rate,
case 
when hour_booked_ahead<=5 then 'On Demand'
else 'Pre Booking'
end as Booking_type


from
(select ar.id,of.status,of.therapist_id,
TIMESTAMPDIFF(hour,of.updated_at,ar.session_time)
as hour_booked_ahead

from appointment_offers of 
join (select id,session_time from appointment_requests where session_time>=last_day(now())+ interval 1 day - interval 3 month) ar on ar.id=of.request_id
where (status='accepted' or status='rejected' or status='terminated')

 ) f
join (select id, concat(first_name,' ', last_name) as name from users where kind='therapist' )u on u.id=f.therapist_id
group by f.therapist_id,Booking_hour
order by Booking_type,acceptance_rate desc


#latest


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