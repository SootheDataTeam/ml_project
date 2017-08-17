
select u.id,date(u.created_at) as signup_date, timestampdiff(day,u.created_at,a.session_time) as how_long_since_sign_up,week(u.created_at) as weeknumber,dayname(u.created_at) as dayofweek,

ifnull(date(most_recent),'2016-09-18') as most_recent_sessions,ifnull(timestampdiff(day,most_recent,session_time),0) as how_long_since_last_session

,case 
    when cnt=1 then 'First Timer'
    when cnt>=2 and cnt<=5 then 'Repeat Customer'
    when  cnt>=6 and cnt<=10 then 'Valued Customer'
    else 'Highly Valued Customer' end as type, signup_type,case when u.promo_code is not null or u.promo_code <>"" then 1 else 0 end as with_promo_code,count(*) sesions_on_that_day,cnt,CASE 
    when source like '%instagram%' or '%Instagram%' then 'Instagram'
    WHEN campaign LIKE '%ROI%' then 'Facebook'
     
    WHEN source like '%yelp%' then 'Yelp'
    
    when ( source like '%facebook%' or  source ='fb') then 'Facebook'
    
    WHEN source like '%google%' then 'Google'
    WHEN source like '%twitter%' then 'Twitter'
    
    when source like '%mail%' then 'Email'
    WHEN source = 'Organic' then 'Organic'
	WHEN source = 'bing' then 'Bing'
     END as channel2, sum(ifnull(credit_amount,0))/sum(session_price) as credit_usage 
    
    
    
from
(select ar.user_id,

case timezone
when 'Europe/London' then
date(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then 
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end
local_date,case ar.session_time when j.tm then 'FT Client' else 'Repeat Client' end as first,c.name as city,session_time,
(select count(*)as cnt from appointment_requests a where a.status='completed' and a.user_id=ar.user_id and a.session_time<ar.session_time)as cnt,credit_amount,session_price,attribution_id,gift_amount

from appointment_requests ar
left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id
join cities c on c.id=ar.city_id
where status ='completed' ) a
join users u on a.user_id=u.id
left join attributions att on att.id=u.attribution_id

left join (select user_id, case timezone
when 'Europe/London' then
date(CONVERT_TZ(max(session_time),'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(max(session_time),'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(max(session_time),'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(max(session_time),'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then 
date(CONVERT_TZ(max(session_time),'UTC','America/Los_Angeles')) end as most_recent
from appointment_requests
where status = 'completed' and date(session_time)<'2016-09-18'
group by user_id
)m on m.user_id=a.user_id  
where local_date='2016-09-18' and first='Repeat Client'
group by u.id
order by type


####a weekbefore

select type,count(*)
from
(select u.id,date(u.created_at) as signup_date, timestampdiff(day,u.created_at,a.session_time) as how_long_since_sign_up,week(u.created_at) as weeknumber,dayname(u.created_at) as dayofweek

,case 
    when cnt=1 then 'First Timer'
    when cnt>=2 and cnt<=5 then 'Repeat Customer'
    when  cnt>=6 and cnt<=10 then 'Valued Customer'
    else 'Highly Valued Customer' end as type, signup_type,case when u.promo_code is not null or u.promo_code <>"" then 1 else 0 end as with_promo_code,a.city
    
    
    
from
(select ar.user_id,

case timezone
when 'Europe/London' then
date(CONVERT_TZ(session_time,'UTC','Europe/London'))
when 'America/Chicago' then
date(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
date(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
date(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then 
date(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) end
local_date,case ar.session_time when j.tm then 'FT Client' else 'Repeat Client' end as first,c.name as city,session_time,credit_amount

from appointment_requests ar
left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id
join cities c on c.id=ar.city_id
where status ='completed') a
join users u on a.user_id=u.id
left join (select user_id, count(*) as cnt
from appointment_requests ar
where ar.status='completed' and date(session_time)<'2016-09-11'
group by user_id
) s on s.user_id=a.user_id

  
where local_date='2016-09-11' and first='Repeat Client'
 
order by type)a
group by type


#### marketing spending

select day,sum(cost)

from marketing_spendings

where day>='2016-09-01'

group by day


















