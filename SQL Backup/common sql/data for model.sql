#neighborhood_demand

select date,nb.zip_code,start_time,end_time,gender_requested,ifnull(sum(cnt),0) as cnt
from
 (select n.city_id,zip_code,neighborhood_bucket_id,nb.name 
from neighborhoods n
join neighborhood_buckets nb on n.neighborhood_bucket_id=nb.id 
where nb.hidden <> 1
group by n.city_id,zip_code) nb 

left join
(select  date(session_time) as date,n.name as city, 
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
hour(session_time-interval  (minute(session_time)*60+second(session_time)) second) as start_time,

hour(session_time-interval  (minute(session_time)*60+second(session_time)) second+interval 10800 second) as end_time,

case  appointment_type 
when 'single' then session_gender_single 
when 'couples' then case when session_gender_double_1<>session_gender_double_2 then 'either' else session_gender_double_1 end
when 'back_to_back' then session_gender_single 
 end as gender_requested,case when appointment_type='couples' then 2 else 1 end as cnt,customer_zip
from appointment_requests ar        
 join (     
    select c.id, c.name
    from cities c
) as n      
on n.id = ar.city_id    


where  ( session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now() and ar.status='cancelled' and (ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) or (ar.id in (select appointment_request_id from appointments where status in ('complete','reviewed') and advanced_appointment_id is not null and session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now() ))) 
 and ar.id not in(select appointment_request_id from therapist_preferences where created_at>=last_day(now()) + interval 1 day -interval 3 month) ) ar
on nb.zip_code=ar.customer_zip 
where neighborhood_bucket_id is not null
group by date,nb.zip_code,start_time,end_time,gender_requested

