
select rank,avg(act_month/sign_up_month) as active_ratio
from
(select a.therapist_id,us.status as rank,count(distinct(date_format(a.session_time,'%Y-%m'))) as act_month,(timestampdiff(month,u.created_at,now())+1) as sign_up_month

from appointments a
join users u on u.id=a.therapist_id
join (select user_id, status from user_scores where user_score_type_id=5) us on us.user_id=a.therapist_id

where a.status in ('complete','reviewed') and u.suspended<>1

group by therapist_id)a
group by rank
 
 
 
###########
 
 select  active_ratio  as avg_active_ratio  
 from
 (select a1.therapist_id,case when act_month/sign_up_month>1 then 1 else act_month/sign_up_month end as active_ratio, bookings_first30
 from
 (select a.therapist_id, count(distinct(date_format(a.session_time,'%Y-%m'))) as act_month,(timestampdiff(month,u.created_at,now())+1) as sign_up_month

from appointments a
join users u on u.id=a.therapist_id

where a.status in ('complete','reviewed') and u.suspended<>1  

group by therapist_id) a1

join

(select a.therapist_id,count(*) as bookings_first30

from appointments a
join users u on u.id=a.therapist_id

where a.status in ('complete','reviewed') and u.suspended<>1 and timestampdiff(day,u.created_at,a.session_time)<30

group by therapist_id)a2 on a1.therapist_id=a2.therapist_id)a
group by  avg_active_ratio