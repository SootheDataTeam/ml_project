
select s1.group_ABC,s1.date,round((s1.total-s2.total)/s2.total,2) as increase_ratio
from
((select group_ABC,date_format(now()-interval 3 month,'%Y-%m') as date ,count(*) as total
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A : Sessions>=250' 
when (count(*)>=80 and count(*)<250) then 'B : Sessions>=80' 
when count(*)<80 then 'C : 0<Sessions<80'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 3 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 3 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 2 month,'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A : Sessions>=250' 
when (count(*)>=80 and count(*)<250) then 'B : Sessions>=80' 
when count(*)<80 then 'C : 0<Sessions<80'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 2 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 2 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 1 month,'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A : Sessions>=250' 
when (count(*)>=80 and count(*)<250) then 'B : Sessions>=80' 
when count(*)<80 then 'C : 0<Sessions<80'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 1 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 1 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now(),'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A : Sessions>=250' 
when (count(*)>=80 and count(*)<250) then 'B : Sessions>=80' 
when count(*)<80 then 'C : 0<Sessions<80'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now())+ interval 1 day-interval 12 month and (a.status='complete' or a.status='reviewed') 



group by therapist_id) f

group by group_ABC)) s1

join((select group_ABC,date_format(now()-interval 3 month,'%Y-%m') as date ,count(*) as total
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A : Sessions>=250' 
when (count(*)>=80 and count(*)<250) then 'B : Sessions>=80' 
when count(*)<80 then 'C : 0<Sessions<80'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 4 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 4 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 2 month,'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A : Sessions>=250' 
when (count(*)>=80 and count(*)<250) then 'B : Sessions>=80' 
when count(*)<80 then 'C : 0<Sessions<80'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 3 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 3 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now()-interval 1 month,'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A : Sessions>=250' 
when (count(*)>=80 and count(*)<250) then 'B : Sessions>=80' 
when count(*)<80 then 'C : 0<Sessions<80'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 2 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 2 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 


group by therapist_id) f

group by group_ABC)
union all
(select group_ABC,date_format(now(),'%Y-%m'),count(*)
from
(
select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A : Sessions>=250' 
when (count(*)>=80 and count(*)<250) then 'B : Sessions>=80' 
when count(*)<80 then 'C : 0<Sessions<80'  end as group_ABC

from appointments a 

where therapist_id not in (19835,6918,102,263) and a.session_time>=last_day(now()-interval 1 month)+ interval 1 day-interval 12 month and a.session_time<last_day(now()-interval 1 month)+ interval 1 day  and (a.status='complete' or a.status='reviewed') 



group by therapist_id) f

group by group_ABC)) s2 on s1.group_ABC=s2.group_ABC and s1.date=s2.date