select ar.user_id,cnt-1 as frequency,case when cnt=1 then 0 else timestampdiff(day,first_s,recent) end as recency, timestampdiff(day,first_s,now())as T,monetary_value
from
(select user_id,count(*) as cnt ,round(avg(session_total_price+ifnull(gift_amount,0)),2) as monetary_value

from appointment_requests
where status ='completed'
group by user_id
) ar
join (select user_id,min(session_time) as first_s,max(session_time)as recent

from appointment_requests
where status ='completed'
group by user_id
) a on a.user_id=ar.user_id
order by ar.user_id



#####

select user_id,min(session_time) as first_s, session_total_price+ifnull(gift_amount,0) as first_revenue

from appointment_requests
where status ='completed'
group by user_id