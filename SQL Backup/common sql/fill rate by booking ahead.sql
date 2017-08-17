select f.hour_booked_ahead,ifnull(sum(case when status not in ('cancelled') then 1 else 0 end)/count(*) ,0) as fill_rate,count(*)

from
(select ar.id,ar.status,
case when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<2 then 'within 3 hour'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<5 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=2 then '3 - 6'
when  TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<8 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=5 then '6 - 9'
when  TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<11 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=8 then '9 - 12'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<14 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=11 then '12 - 15'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<17 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=14 then '15 - 18'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<20 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=17 then '18 - 21'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<23 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=20 then '21 - 24'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<26 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=23 then '24 - 27'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<29 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=26 then '27 - 30'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<32 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=29 then '30 - 33'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<35 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=32 then '33 - 36'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<38 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=35 then '36 - 39'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<41 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=38 then '39 - 42'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<44 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=41 then '42 - 45'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<47 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=44 then '45 - 48' 
else 'more than 48 hours' end

 as hour_booked_ahead
 


from appointment_requests ar 


where (ar.status ='completed' or ar.status ='filled' or (ar.status='cancelled' and is_unfilled is true)) 
and session_time>=last_day(now())+interval 1 day-interval 12 month) f
group by  f.hour_booked_ahead
order by f.hour_booked_ahead 

#####

select f.hour_booked_ahead,ifnull(sum(case when status not in ('cancelled') then 1 else 0 end)/count(*) ,0) as fill_rate,count(*)

from
(select ar.id,ar.status,
case when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<2 then 'within 3 hour'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<5 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=2 then '3 - 6'
when  TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<8 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=5 then '6 - 9'
when  TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<11 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=8 then '9 - 12'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<14 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=11 then '12 - 15'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<17 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=14 then '15 - 18'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<20 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=17 then '18 - 21'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<23 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=20 then '21 - 24'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<26 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=23 then '24 - 27'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<29 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=26 then '27 - 30'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<32 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=29 then '30 - 33'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<35 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=32 then '33 - 36'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<38 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=35 then '36 - 39'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<41 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=38 then '39 - 42'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<44 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=41 then '42 - 45'
when TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)<47 and TIMESTAMPDIFF(hour,ar.created_at,ar.session_time)>=44 then '45 - 48' 
else 'more than 48 hours' end

 as hour_booked_ahead
 


from appointment_requests ar 


where (ar.status ='completed' or ar.status ='filled' or (ar.status='cancelled' and is_unfilled is true)) 
and session_time>=last_day(now())+interval 1 day-interval 12 month) f