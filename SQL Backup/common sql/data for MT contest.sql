
# Bookings 
select u.id,concat(u.first_name," ",u.last_name),count(*) as cnt


from appointment_requests ar
join appointments a on a.appointment_request_id=ar.id
join users u on u.id=a.therapist_id
 
where a.status in ('complete','reviewed') and date(CONVERT_TZ(ar.session_time,'UTC',ar.timezone))>='2016-08-21' and date(CONVERT_TZ(ar.session_time,'UTC',ar.timezone))<='2016-09-21' and therapist_id=204900
 
group by u.id
order by cnt desc
limit 3


##repeat bookings



select u.id,concat(u.first_name," ",u.last_name) as name,count(*) as cnt

from
 (select   a.therapist_id,a.user_id,count(*) as cnt


from appointment_requests ar
 

join appointments a on a.appointment_request_id=ar.id

 
where a.status in ('complete','reviewed') and date(CONVERT_TZ(ar.session_time,'UTC',ar.timezone))>='2016-09-21' and date(CONVERT_TZ(ar.session_time,'UTC',ar.timezone))<='2016-10-21'

 
group by a.therapist_id,a.user_id) a

join users u on u.id=a.therapist_id
where a.cnt>1
group by u.id


order by cnt desc
limit 3



#####Client Rating

select u.id,concat(u.first_name," ",u.last_name) as name,rating
from
(select a.therapist_id,avg(r.value) as rating

from reviews r
join appointments a on a.id=r.appointment_id
where  r.recipient_id=r.therapist_id and a.therapist_id in (select therapist_id from (select a.therapist_id,count(*) as cnt


from appointment_requests ar
join appointments a on a.appointment_request_id=ar.id
 
 
where a.status in ('complete','reviewed') and date(CONVERT_TZ(ar.session_time,'UTC',ar.timezone))>='2016-09-21' and date(CONVERT_TZ(ar.session_time,'UTC',ar.timezone))<='2016-10-21'

group by a.therapist_id)a where a.cnt>=10)
group by a.therapist_id) a
join users u on u.id=a.therapist_id
order by rating desc
limit 3
 



####Growth

select u.id,concat(u.first_name," ", u.last_name) as name ,ifnull(a1.cnt/a2.cnt-1,0) as growth


from
(select  a.therapist_id,count(*) as cnt


from appointment_requests ar
join appointments a on a.appointment_request_id=ar.id
 
 
where a.status in ('complete','reviewed') and date(CONVERT_TZ(ar.session_time,'UTC',ar.timezone))>='2016-09-21' and date(CONVERT_TZ(ar.session_time,'UTC',ar.timezone))<='2016-10-21' 

group by a.therapist_id)a1

join
(select  a.therapist_id,count(*) as cnt


from appointment_requests ar
join appointments a on a.appointment_request_id=ar.id
 
 
where a.status in ('complete','reviewed') and date(CONVERT_TZ(ar.session_time,'UTC',ar.timezone))>='2016-08-21' and date(CONVERT_TZ(ar.session_time,'UTC',ar.timezone))<='2016-09-21'

group by a.therapist_id)a2 on a1.therapist_id=a2.therapist_id

join users u on u.id=a1.therapist_id
where a2.cnt>=10 and u.suspended<>1
order by growth desc
limit 4





