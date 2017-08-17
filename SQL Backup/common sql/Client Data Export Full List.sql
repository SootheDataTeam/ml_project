select id,name,completed_appointments,weekly_freq,email,ifnull(client_type,'None Bookers') as client_type,Risk,last_booking_date,Account_Created_At
from
(select u.id, concat(u.first_name," ", u.last_name) as name, num_completed_requests as completed_appointments,weekly_freq, email,
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>1 then 'C2'
when num_completed_requests=1 then 'C1' end as client_type, case when recency>2 * freq then 1 else 0 end as Risk,last_booking_date,date(created_at) as Account_Created_At
from
users u
left join
(SELECT
user_id,
DATEDIFF(current_date(),min(DATE(ar.created_at))) tenure,
DATEDIFF(current_date(),max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(current_date(),min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(current_date(),min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq,date(max(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))) as last_booking_date 

FROM
appointment_requests ar
WHERE status='completed' OR (status='cancelled' AND is_unfilled=1)
group by user_id) a on a.user_id=u.id
where u.kind='client'
) a 
order by client_type
 