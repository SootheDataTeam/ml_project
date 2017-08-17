#neighborhood_demand
select f.*
from
(select t.*,
case day
when  'Monday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 7 day),'%Y-%m-%d')," ",t.start_time)
when 'Tuesday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 8 day),'%Y-%m-%d')," ",t.start_time)
When 'Wednesday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 9 day),'%Y-%m-%d')," ",t.start_time)
When 'Thursday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 10 day),'%Y-%m-%d')," ",t.start_time)
when 'Friday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 11 day),'%Y-%m-%d')," ",t.start_time)
when 'Saturday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 12 day),'%Y-%m-%d')," ",t.start_time)
when 'Sunday' then concat(date_format(date_add(date_sub(now() , interval dayofweek(now()) - 1 day ), interval 7 day),'%Y-%m-%d')," ",t.start_time)
end as predict_start_date,
case when t.start_time<t.end_time then
case day
when  'Monday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 7 day),'%Y-%m-%d')," ",t.end_time)
when 'Tuesday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 8 day),'%Y-%m-%d')," ",t.end_time)
When 'Wednesday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 9 day),'%Y-%m-%d')," ",t.end_time)
When 'Thursday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 10 day),'%Y-%m-%d')," ",t.end_time)
when 'Friday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 11 day),'%Y-%m-%d')," ",t.end_time)
when 'Saturday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 12 day),'%Y-%m-%d')," ",t.end_time)
when 'Sunday'   then concat(date_format(date_add(date_sub(now() , interval dayofweek(now()) - 1 day ), interval 7 day),'%Y-%m-%d')," ",t.end_time)
end
else 
case day
when  'Monday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 8 day),'%Y-%m-%d')," ",t.end_time)
when 'Tuesday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 9 day),'%Y-%m-%d')," ",t.end_time)
When 'Wednesday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 10 day),'%Y-%m-%d')," ",t.end_time)
When 'Thursday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 11 day),'%Y-%m-%d')," ",t.end_time)
when 'Friday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 12 day),'%Y-%m-%d')," ",t.end_time)
when 'Saturday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 13 day),'%Y-%m-%d')," ",t.end_time)
when 'Sunday'   then concat(date_format(date_add(date_sub(now() , interval dayofweek(now()) - 1 day ), interval 8 day),'%Y-%m-%d')," ",t.end_time)
end
end as predict_end_date
from
(select  nb.neighborhood_bucket_id, n.name as city, 
case timezone
when 'Europe/London' then
weekday(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
weekday(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
weekday(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
weekday(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
weekday(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as dayofweek,
case timezone
when 'Europe/London' then
dayname(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
dayname(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
dayname(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
dayname(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
dayname(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as day,
date_format(session_time-interval  (minute(session_time)*60+second(session_time)) second  , '%H:%i:%s') as start_time,
date_format(session_end_time+interval  (7200-minute(session_end_time)*60-second(session_end_time)) second, '%H:%i:%s')as end_time,



case  appointment_type 
when 'single' then session_gender_single 
when 'couples' then case when session_gender_double_1<>session_gender_double_2 then 'either' else session_gender_double_1 end
when 'back_to_back' then session_gender_single 
 end as gender_requested,
 round(sum(case when appointment_type='couples' then 2 else 1 end)/(select cnt from (select dayname(local_date) as local_day,count(*) as cnt
from
(
select case timezone
when 'Europe/London' then
date(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as local_date 
from appointment_requests
where  session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now()
group by local_date) f
group by local_day)m
where m.local_day= dayname(ar.session_time)),2)as Avg_cancellation,count(*)
from appointment_requests ar        
left join (     
    select c.id, c.name
    from cities c
) as n      
on n.id = ar.city_id    
left join (select n.city_id,zip_code,neighborhood_bucket_id,nb.name 
from neighborhoods n
join neighborhood_buckets nb on n.neighborhood_bucket_id=nb.id 
where nb.hidden <> 1
group by n.city_id,zip_code) nb on nb.zip_code=ar.customer_zip 
where  ( session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now() and ar.status='cancelled' and (ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) or (ar.id in (select appointment_request_id from appointments where status in ('complete','reviewed') and advanced_appointment_id is not null and session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now() ))) 
and neighborhood_bucket_id is not null and ar.id not in(select appointment_request_id from therapist_preferences where created_at>=last_day(now()) + interval 1 day -interval 3 month) 
group by city,day,start_time, end_time,gender_requested
having gender_requested is not null
order by dayofweek,start_time,end_time,gender_requested) t) f
where day=dayname(convert_tz(now(),'UTC','US/Pacific'))
order by Avg_cancellation desc
limit 50
