
select a1.user_id,a1.city as first_city,a1.complete as first_city_session,a2.city as last_city,a2.complete as last_city_session
from
(select o.user_id,o.city,complete
from
(select user_id,c.name as city,count(*) as complete

from appointment_requests  ar
join cities c on c.id=ar.city_id
where ar.status='completed'  

group by user_id,city) o 



join 


(select user_id,city
from
(select user_id,c.name as city

from appointment_requests  ar
join cities c on c.id=ar.city_id
where ar.status='completed'  
 
order by session_time asc)a 
group by user_id ) c on o.user_id=c.user_id and o.city=c.city)a1
join
(select o.user_id,o.city,complete
from
(select user_id,c.name as city,count(*) as complete

from appointment_requests  ar
join cities c on c.id=ar.city_id
where ar.status='completed' 

group by user_id,city) o 



join 


(select user_id,city
from
(select user_id,c.name as city

from appointment_requests  ar
join cities c on c.id=ar.city_id
where ar.status='completed' 
 
order by session_time desc)a 
group by user_id ) c on o.user_id=c.user_id and o.city=c.city)a2 on a1.user_id=a2.user_id

where a1.city<>a2.city