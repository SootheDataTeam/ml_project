select tx.city,tx.neighborhood_bucket_id,tx.neighborhood_bucket,tx.day,tx.hour_local,tx.session_gender_requested,count(*)/(select count(*) from (select case session_type when 'couples' then session_couples_gender else session_gender_requested end as session_gender_requested,
dayname(session_time) as day,nb.neighborhood_bucket_id,nb.name as neighborhood_bucket,n.name as city,weekday(session_time) as dayofweek,status,
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
hour(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as hour_local



from appointment_requests ar		
left join (		
	select c.id, c.name
    from cities c
) as n		
on n.id = ar.city_id	
left join (select n.city_id,zip_code,neighborhood_bucket_id,nb.name 
from neighborhoods n
join neighborhood_buckets nb on n.neighborhood_bucket_id=nb.id and nb.city_id=n.city_id) nb on nb.zip_code=ar.customer_zip and nb.city_id=ar.city_id

where  session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now() and (  ar.status='cancelled' and ar.id in (select id
from appointment_requests ar

where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) 
) tx1 where tx1.city_id=tx.city_id and tx.neighborhood_bucket_id=tx1.neighborhood_bucket_id and tx1.day=tx.day and tx1.hour_local=tx.hour_local and tx1.session_gender_requested=tx.session_gender_requested) as avg_cancellation
from
(select case session_type when 'couples' then session_couples_gender else session_gender_requested end as session_gender_requested,
dayname(session_time) as day,nb.neighborhood_bucket_id,nb.name as neighborhood_bucket,n.name as city,weekday(session_time) as dayofweek,status,
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
hour(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') )end as hour_local



from appointment_requests ar		
left join (		
	select c.id, c.name
    from cities c
) as n		
on n.id = ar.city_id	
left join (select n.city_id,zip_code,neighborhood_bucket_id,nb.name 
from neighborhoods n
join neighborhood_buckets nb on n.neighborhood_bucket_id=nb.id and nb.city_id=n.city_id) nb on nb.zip_code=ar.customer_zip and nb.city_id=ar.city_id

where  session_time>=last_day(now()) + interval 1 day -interval 3 month and session_time<= now() and (  ar.status='cancelled' and ar.id in (select id
from appointment_requests ar

where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) 
) tx
group by tx.city,tx.neighborhood_bucket_id,tx.day,tx.hour_local,tx.session_gender_requested



