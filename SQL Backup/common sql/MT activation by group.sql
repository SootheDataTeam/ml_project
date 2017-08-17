
### MT activated by group
select f.therapist_id as ID,u.first_name,u.last_name,u.mobile_number as mobile,u.email,f.group_ABC,f.total as total  
from
(select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A : Sessions>=250' 
when (count(*)>=80 and count(*)<250) then 'B : Sessions>=80' 
when count(*)<80 then 'C : Sessions<80'  end as group_ABC

from appointments a 

where   therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 1 month)+ interval 1 day-interval 12 month and a.session_time <last_day(now()-interval 1 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') and therapist_id in (select m.therapist_id
from (select DATE_FORMAT(ap.session_time,'%Y-%m') as date,ap.therapist_id

from appointments ap

where (ap.status = 'complete' or ap.status = 'reviewed') and DATE_FORMAT(ap.session_time,'%Y-%m')=DATE_FORMAT(now()-interval 1 month,'%Y-%m')

group by date,ap.therapist_id) m)
group by therapist_id) f
left join users u on u.id=f.therapist_id

 
order by total  desc


### MT not activated by group
 select f.therapist_id as ID,u.first_name,u.last_name,u.mobile_number as mobile,u.email,
case when total>=250 then 'A : Sessions>=250' 
when (total>=80 and total<250) then 'B : Sessions>=80' 
else  'C : Sessions<80'  end as group_ABC  

from
  (select id,u.first_name,u.last_name,u.mobile_number,u.email from users u where kind='therapist' ) u
left join
(select a.therapist_id, count(*) as total

from appointments a 

where   therapist_id not in (19835,6918,102,263) and  a.session_time>=last_day(now()-interval 1 month)+ interval 1 day-interval 12 month and a.session_time <last_day(now()-interval 1 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 
group by therapist_id) f on u.id=f.therapist_id
 
where id not in (select m.therapist_id
from (select DATE_FORMAT(ap.session_time,'%Y-%m') as date,ap.therapist_id

from appointments ap

where (ap.status = 'complete' or ap.status = 'reviewed') and DATE_FORMAT(ap.session_time,'%Y-%m')=DATE_FORMAT(now()-interval 1 month,'%Y-%m')

group by date,ap.therapist_id) m)
order by group_ABC