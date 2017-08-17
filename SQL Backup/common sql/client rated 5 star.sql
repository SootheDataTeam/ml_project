select concat(u.first_name," ", u.last_name) as name,u.email,ar.city

from
(select client_id from (select client_id,avg(value) av from reviews where recipient_id=client_id group by client_id)a where av=5) r

join users u on u.id=r.client_id


join (select user_id, min(session_time),c.name as city from appointment_requests ar
join cities c on c.id=ar.city_id 
 where status='completed' group by user_id) ar on ar.user_id=u.id
 
 
 select * from users where concat(first_name," ", last_name)='Tony Christos'
 
 
  select * from users where email='mema2@bellsouth.net'
 