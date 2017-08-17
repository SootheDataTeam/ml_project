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
where (status='accepted' or status='rejected' )

 ) f
join (select id, concat(first_name,' ', last_name) as name from users where kind='therapist' )u on u.id=f.therapist_id
group by f.therapist_id,f.hour_booked_ahead
order by f.therapist_id,f.hour_booked_ahead


##### test

select * from appointment_offers
where (status='accepted' or status='rejected') and updated_at>=last_day(now())+ interval 1 day - interval 12 month