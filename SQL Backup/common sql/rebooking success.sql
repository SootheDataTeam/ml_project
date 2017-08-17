

#### Direct Rebook
select u.id as Agent_id,concat(u.first_name,' ',u.last_name) as agent_name ,a.auditable_type,ar.id as appointment_request_id,ar.user_id,(select concat(first_name,' ',last_name) as name from users where id=ar.user_id) as client_name,us1.status as Rank,us2.status as At_Risk,convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end) as session_time ,ar.status 
from audits a
join appointment_requests ar
on a.auditable_id = ar.id
join users u on u.id=a.user_id
left join (select user_id,status from  user_scores where user_score_type_id=4 group by user_id) us1 on us1.user_id=ar.user_id
left join (select user_id,status from  user_scores where user_score_type_id=9 group by user_id) us2 on us2.user_id=ar.user_id
where a.auditable_id = 3085974 and a.action='create' 


#### InDirect Rebook




select appointent_request_id from appointment_comments

select count(*)

from user_scores

where user_score_type_id=9 and status='At Risk'

### rebook success

select ac.agent,ac.name,date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as session_date,ac.user_id as client_id
from
appointment_requests ar
join (select user_id as agent,concat(u.first_name,' ',u.last_name) as name,ac.profile_user_id as user_id,convert_tz(ac.created_at,'UTC','US/Pacific')

from appointment_comments ac 

join (select id,max(created_at),profile_user_id from appointment_comments where comment like '%CRB%'   and appointment_request_id is null group by profile_user_id) ac1 on ac1.id=ac.id
      
join users u on u.id=ac.user_id

where comment like '%CRB%'   and appointment_request_id is null

 ) ac on ac.user_id=ar.user_id

where  ar.status='completed' and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>='2017-05-01'


select ad.user_id  as agent_id,concat(u.first_name,' ',u.last_name) as name  ,date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else ar.timezone end)) as session_date ,ar.user_id as client_id

from appointment_requests  ar

join audits ad on ad.auditable_id=ar.id
join users u on u.id=ad.user_id

where ar.status='completed' and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else ar.timezone end))>='2017-05-01' and ad.action='create' and ad.user_id in (374878,401253,345666,91787,382140,225867)

group by name




 