select case session_type when 'couples' then session_couples_gender else session_gender_requested end as session_gender_requested,dayname(session_time) as day,nb.neighborhood_bucket_id,nb.name as neighborhood_bucket,n.name as city,weekday(session_time) as dayofweek,status,
case timezone
when 'Europe/London' then
hour(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
hour(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
hour(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
hour(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
hour(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as local_hour



from appointment_requests ar		
left join (		
	select c.id, c.name
    from cities c
) as n		
on n.id = ar.city_id	
left join (select n.city_id,zip_code,neighborhood_bucket_id,nb.name 
from neighborhoods n
join neighborhood_buckets nb on n.neighborhood_bucket_id=nb.id and nb.city_id=n.city_id) nb on nb.zip_code=ar.customer_zip and nb.city_id=ar.city_id

where  (  ar.status='cancelled' and ar.id in (select id
from appointment_requests ar

where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) 




select dayname(local_date) as local_day,count(*)
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
group by local_day


#######modified

select case session_type when 'couples' then session_couples_gender else session_gender_requested end as session_gender_requested,dayname(session_time) as day,nb.neighborhood_bucket_id,nb.name as neighborhood_bucket,n.name as city,weekday(session_time) as dayofweek,count(*), round(count(*)/(select cnt from (select dayname(local_date) as local_day,count(*) as cnt
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
where m.local_day= dayname(ar.session_time)),2)as Avg_cancellation,
case timezone
when 'Europe/London' then
hour(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
hour(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
hour(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
hour(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
hour(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as local_hour



from appointment_requests ar		
left join (		
	select c.id, c.name
    from cities c
) as n		
on n.id = ar.city_id	
left join (select n.city_id,zip_code,neighborhood_bucket_id,nb.name 
from neighborhoods n
join neighborhood_buckets nb on n.neighborhood_bucket_id=nb.id and nb.city_id=n.city_id
group by n.city_id,zip_code) nb on nb.zip_code=ar.customer_zip and nb.city_id=ar.city_id

where  ( session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now() and ar.status='cancelled' and ar.id in (select id
from appointment_requests ar

where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) and neighborhood_bucket_id is not null and session_gender_requested is not null
group by city,neighborhood_bucket_id,day,local_hour,session_gender_requested

order by count(*) desc


#######modified2
select t.*,concat('2016',t.start_time),t.end_time
from
(select  nb.neighborhood_bucket_id,nb.name as neighborhood_bucket,n.name as city, 
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
dayname(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as day,date_format(session_time, '%H:%i:%s') as start_time,date_format(session_end_time, '%H:%i:%s')as end_time,case session_type when 'couples' then session_couples_gender else session_gender_requested end as gender_requested,round(count(*)/(select cnt from (select dayname(local_date) as local_day,count(*) as cnt
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
group by n.city_id,zip_code) nb on nb.zip_code=ar.customer_zip 

where  ( session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now() and ar.status='cancelled' and ar.id in (select id
from appointment_requests ar

where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) and neighborhood_bucket_id is not null 
group by city,neighborhood_bucket_id,day,start_time, end_time,session_gender_requested
having gender_requested is not null

order by dayofweek,start_time,end_time,gender_requested) t


#####modified 3



#######modified3
select t.*,

case day
when  'Monday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 7 day),'%Y-%m-%d')," ",t.start_time)
when 'Tuesday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 8 day),'%Y-%m-%d')," ",t.start_time)
When 'Wednsday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 9 day),'%Y-%m-%d')," ",t.start_time)
When 'Thursday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 10 day),'%Y-%m-%d')," ",t.start_time)
when 'Friday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 11 day),'%Y-%m-%d')," ",t.start_time)
when 'Saturday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 12 day),'%Y-%m-%d')," ",t.start_time)
when 'Sunday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 13 day),'%Y-%m%d')," ",t.start_time)


end as predict_start_date,
case when t.start_time<t.end_time then
case day
when  'Monday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 7 day),'%Y-%m-%d')," ",t.end_time)
when 'Tuesday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 8 day),'%Y-%m-%d')," ",t.end_time)
When 'Wednsday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 9 day),'%Y-%m-%d')," ",t.end_time)
When 'Thursday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 10 day),'%Y-%m-%d')," ",t.end_time)
when 'Friday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 11 day),'%Y-%m-%d')," ",t.end_time)
when 'Saturday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 12 day),'%Y-%m-%d')," ",t.end_time)
when 'Sunday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 13 day),'%Y-%m-%d')," ",t.end_time)
end
else 
case day
when  'Monday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 8 day),'%Y-%m-%d')," ",t.end_time)
when 'Tuesday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 9 day),'%Y-%m-%d')," ",t.end_time)
When 'Wednsday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 10 day),'%Y-%m-%d')," ",t.end_time)
When 'Thursday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 11 day),'%Y-%m-%d')," ",t.end_time)
when 'Friday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 12 day),'%Y-%m-%d')," ",t.end_time)
when 'Saturday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 13 day),'%Y-%m-%d')," ",t.end_time)
when 'Sunday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 14 day),'%Y-%m-%d')," ",t.end_time)
end
end as predict_end_date



from
(select  nb.neighborhood_bucket_id,nb.name as neighborhood_bucket,n.name as city, 
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
dayname(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as day,date_format(session_time, '%H:%i:%s') as start_time,date_format(session_end_time, '%H:%i:%s')as end_time,case session_type when 'couples' then session_couples_gender else session_gender_requested end as gender_requested,round(count(*)/(select cnt from (select dayname(local_date) as local_day,count(*) as cnt
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
group by n.city_id,zip_code) nb on nb.zip_code=ar.customer_zip 

where  ( session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now() and ar.status='cancelled' and ar.id in (select id
from appointment_requests ar

where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) and neighborhood_bucket_id is not null 
group by city,neighborhood_bucket_id,day,start_time, end_time,session_gender_requested
having gender_requested is not null

order by dayofweek,start_time,end_time,gender_requested) t


#####modified 4
select t.*,

case day
when  'Monday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 7 day),'%Y-%m-%d')," ",t.start_time)
when 'Tuesday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 8 day),'%Y-%m-%d')," ",t.start_time)
When 'Wednsday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 9 day),'%Y-%m-%d')," ",t.start_time)
When 'Thursday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 10 day),'%Y-%m-%d')," ",t.start_time)
when 'Friday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 11 day),'%Y-%m-%d')," ",t.start_time)
when 'Saturday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 12 day),'%Y-%m-%d')," ",t.start_time)
when 'Sunday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 13 day),'%Y-%m%d')," ",t.start_time)


end as predict_start_date,
case when t.start_time<t.end_time then
case day
when  'Monday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 7 day),'%Y-%m-%d')," ",t.end_time)
when 'Tuesday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 8 day),'%Y-%m-%d')," ",t.end_time)
When 'Wednsday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 9 day),'%Y-%m-%d')," ",t.end_time)
When 'Thursday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 10 day),'%Y-%m-%d')," ",t.end_time)
when 'Friday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 11 day),'%Y-%m-%d')," ",t.end_time)
when 'Saturday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 12 day),'%Y-%m-%d')," ",t.end_time)
when 'Sunday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 13 day),'%Y-%m-%d')," ",t.end_time)
end
else 
case day
when  'Monday'  then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 8 day),'%Y-%m-%d')," ",t.end_time)
when 'Tuesday' then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 9 day),'%Y-%m-%d')," ",t.end_time)
When 'Wednsday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 10 day),'%Y-%m-%d')," ",t.end_time)
When 'Thursday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 11 day),'%Y-%m-%d')," ",t.end_time)
when 'Friday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 12 day),'%Y-%m-%d')," ",t.end_time)
when 'Saturday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 13 day),'%Y-%m-%d')," ",t.end_time)
when 'Sunday'   then concat(date_format(date_add(date_sub(now(), interval dayofweek(now()) -2 day ), interval 14 day),'%Y-%m-%d')," ",t.end_time)
end
end as predict_end_date



from
(select  nb.neighborhood_bucket_id,nb.name as neighborhood_bucket,n.name as city, 
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
dayname(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end as day,date_format(session_time, '%H:%i:%s') as start_time,date_format(session_end_time, '%H:%i:%s')as end_time,case session_type when 'couples' then session_couples_gender else session_gender_requested end as gender_requested,round(count(*)/(select cnt from (select dayname(local_date) as local_day,count(*) as cnt
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
group by n.city_id,zip_code) nb on nb.zip_code=ar.customer_zip 

where  ( session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now() and (ar.advanced_reservation=1 and ar.status='completed') or( ar.status='cancelled' and ar.id in (select id
from appointment_requests ar

where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) )) and neighborhood_bucket_id is not null 
group by city,neighborhood_bucket_id,day,start_time, end_time,session_gender_requested
having gender_requested is not null

order by dayofweek,start_time,end_time,gender_requested) t


