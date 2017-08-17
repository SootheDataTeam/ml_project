###
 SELECT
lane,
case when status is not null then status else 'NB' end as type,
mon,
count(*)
FROM
(SELECT id,
SUBSTRING(id,-1,1) lane,
date_format(created_at,'%Y/%m') mon
FROM users
WHERE kind = 'client') ulane
LEFT JOIN (select * from user_scores WHERE user_score_type_id = 4) u ON (ulane.id=u.user_id)

GROUP BY
1,2,3;



#####


select *

from
(select SUBSTRING(u.id,-1,1) as lane,concat(u.first_name,' ',u.last_name) as name, email,
case when uc.status is null then 'NB'
when uc.status='None' then 'NB'
else uc.status end as client_rank
, case when credits>=30 then 1 else 0 end as credit_more_than_30
from users u
left join (select * from user_scores where user_score_type_id=4)uc on uc.user_id=u.id
where kind='client'  )  a
where client_rank='NB'