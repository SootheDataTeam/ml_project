select td.longitude,td.latitude,ar.longitude,ar.latitude from therapist_distance_from_appointments td

join appointments a on a.id=td.appointment_id
join appointment_requests ar on ar.id=a.appointment_request_id

where minutes_till_appointment_starts<0




select * from therapist_distance_from_appointments


select * from therapist_locations


select case when  

from appointment_requests

where status ='completed' and 






select ar.id,session_gender_single,appointment_type,hour(convert_tz(session_time,'UTC',ar.timezone)) as local_hour,dayname(convert_tz(session_time,'UTC',ar.timezone)) as Day_of_week,timestampdiff(hour,created_at,session_time) as book_hour_ahead,ar.longitude,ar.latitude




from appointment_requests ar

where appointment_type='single' and status='completed' and customer_zip in (90046 ,
90048 ,
90069 ,
90038 ,
90036 ,
90046 ,
90048 ,
90069) 


order by session_time desc



select * from neighborhoods where city_id=2 and name='West Hollywood'




select a.therapist_id, appointment_type,ar.session_length,hour(convert_tz(ar.session_time,'UTC',ar.timezone)) as local_hour,
dayname(convert_tz(ar.session_time,'UTC',ar.timezone)) as Day_of_week,
timestampdiff(hour,ar.created_at,ar.session_time) as book_hour_ahead,nb.name,case when a.status ='cancelled' then 0 else 1 end as y

from appointments a
join appointment_requests ar on a.appointment_request_id=ar.id
join neighborhoods nb on nb.zip_code=ar.customer_zip
where a.status in ('complete','reviewed','cancelled') and a.therapist_id in (635,336561,177962,243021,336448,260901,38318,7571,184015,290750) and hour(convert_tz(ar.session_time,'UTC',ar.timezone)) is not null









select convert_tz(now(),'UTC','Pacific Time (US & Canada)')


select count(*) from appointment_requests where timezone='Pacific Time (US & Canada)' and date(session_time)>='2016-01-01' and status='completed'


select distinct(a.therapist_id)

from appointments a
join appointment_requests ar on a.appointment_request_id=ar.id

where ar.city_id=2 and a.status in ('complete','reviewed') and month(a.session_time)=10 and year(a.session_time)=2016


select id,gender

from users 

where id in (635,336561,177962,243021,290750,336448,260901,38318,7571,184015)

