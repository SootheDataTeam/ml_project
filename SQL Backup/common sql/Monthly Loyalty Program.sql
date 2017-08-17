
select date,sum(reward) as monthly_reward_total,count(distinct(user_id)) as reward_client_cnt

from
(select user_id,date,case when (session_length_hour>=3 and session_length_hour<7) then 10
        when (session_length_hour>=7 and session_length_hour<11) then 25
        when (session_length_hour>=11 and session_length_hour<13) then 45
        when (session_length_hour>=13 and session_length_hour<17) then 60
        when (session_length_hour>=17 and session_length_hour<21) then 70
        when (session_length_hour>=21 and session_length_hour<25) then 95
        when (session_length_hour>=25) then 125 else 0 end as reward
from
(select user_id,DATE_FORMAT(session_time,'%Y-%m') as date,sum(ifnull(session_length,0)/60)as session_length_hour

from appointment_requests

where status='completed' and date_format(session_time,'%Y-%m')>='2016-05' and date_format(session_time,'%Y-%m')<='2017-05' and user_id=109

group by user_id,date
 )a)a
where reward>0
group by date