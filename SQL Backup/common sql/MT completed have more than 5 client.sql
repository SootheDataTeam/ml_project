select a.therapist_id,concat(u.first_name," ", u.last_name) as MT_Name,u.mobile_number ,u.email,count(distinct(ar.user_id)) as cnt ,nb.name as neighborhood
from appointment_requests ar

join
(select zip_code,name from neighborhoods  where name in ('West Hollywood','Beverly Hills','Calabasas','Malibu','Upper West Side','Upper East Side','Chelsea','Greenwich Village'))nb on nb.zip_code=ar.customer_zip

 join appointments a on a.appointment_request_id=ar.id
 join users u on u.id=a.therapist_id
 where a.status in ('complete','reviewed')
 group by a.therapist_id,neighborhood
  having cnt>=5
 order by neighborhood desc, cnt desc

 
 