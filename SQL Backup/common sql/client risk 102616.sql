#client risk
select *
from
(select a.user_id as id,case when recency>2*freq then 'At Risk' else 'Not At Risk' end as Risk,
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type



from
(SELECT
user_id,
DATEDIFF(current_date(),min(DATE(ar.created_at))) tenure,
DATEDIFF(current_date(),max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(current_date(),min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(current_date(),min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE status='completed' OR (status='cancelled' AND is_unfilled=1)
group by user_id) a
join users u on u.id=a.user_id
join (select user_id,min(session_time),c.name as city from appointment_requests ar join cities c on c.id=ar.city_id where status='completed' group by user_id) m on m.user_id=a.user_id


)a1
 
