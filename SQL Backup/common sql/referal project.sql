
select u.id,concat(u.first_name," ",u.last_name) as name, first_session,count(*) as num_referal,count(*)*30 as reward
from users u 
join
(select id, promo_code, date_format(first_session,'%Y-%m') as first_session

from users u
join (select user_id,min(session_time) as first_session,timezone from appointment_requests where status='completed' group by user_id) ar on ar.user_id=u.id
where kind='client' and promo_code is not null and promo_code <>'') u1 on u1.promo_code=u.invite_code
where kind='client' and invite_code is not null and invite_code<>''
group by u.id,first_session


select id ,invite_code
from users 
where kind='client' and invite_code is not null