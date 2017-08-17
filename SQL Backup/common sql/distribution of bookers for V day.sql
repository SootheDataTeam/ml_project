select  user_id,timestampdiff(day,created_at,session_time) as Account_Age
from
(select 
case timezone

when 'Europe/London' then
date(CONVERT_TZ(ar.session_time,'UTC','Europe/London'))
when 'Australia/Sydney' then
date(CONVERT_TZ(ar.session_time,'UTC','Australia/Sydney'))
when 'America/Chicago' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(ar.session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Phoenix'))
when 'America/Indiana/Indianapolis' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Indiana/Indianapolis'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Los_Angeles') ) end as date_local,case ar.session_time when j.tm then 'FT' else 'Repeat' end as first,ar.user_id,session_time
from appointment_requests ar
left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id

where ar.status='completed' 
 
having date_local='2016-05-08' and first='FT'
)a
 join users u on u.id=a.user_id
 
 
 
############
 
 select  a.user_id,timestampdiff(month,created_at,session_time) as Account_Age,case when client_type is null then 'NB' else client_type end as client_type,Risk
from
(select 
case timezone

when 'Europe/London' then
date(CONVERT_TZ(ar.session_time,'UTC','Europe/London'))
when 'Australia/Sydney' then
date(CONVERT_TZ(ar.session_time,'UTC','Australia/Sydney'))
when 'America/Chicago' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(ar.session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Phoenix'))
when 'America/Indiana/Indianapolis' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Indiana/Indianapolis'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date(CONVERT_TZ(ar.session_time,'UTC','America/Los_Angeles') ) end as date_local,case ar.session_time when j.tm then 'FT' else 'Repeat' end as first,ar.user_id,session_time
from appointment_requests ar
left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id

where ar.status='completed' 
 
having date_local='2016-05-08' and first='Repeat'
)a
  join users u on u.id=a.user_id
 left join 
 (select  user_id,
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type ,case when recency>2*freq then 'At Risk' else 'Not At Risk' end as Risk

 

from
(SELECT
user_id,
DATEDIFF('2016-05-08',min(DATE(ar.created_at))) tenure,
DATEDIFF('2016-05-08',max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF('2016-05-08',min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF('2016-05-08',min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1))  and date(session_time)<'2016-05-08'
group by user_id
having num_completed_requests>=1 )s) a2 on a.user_id=a2.user_id
where client_type='C'
 
 
 