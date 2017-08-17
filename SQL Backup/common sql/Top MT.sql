

set @group='', @row = 0,@city='';

select id,date,city,rank,concat(city,rank) as merge,cnt,name
from
(select id,name,date,city,cnt,case when @group<>id and @city=city then @row:=@row+1 else 1 and @row:=1 end as rank, @group:=id,@city:=city
from
(select u.id,concat(u.first_name," ", u.last_name) as name,a.date,city,count(*) as cnt
from users u


join 
(select therapist_id,date_format(session_time,'%Y-%m') as date
from
appointments a
where status in ('complet','reviewed') and session_time>=last_day(now())+interval 1 day -interval 2 month and session_time<last_day(now())+interval 1 day -interval 1 month) a on a.therapist_id=u.id

group by a.date,city,u.id
order by a.date,city,cnt desc) a1)a2
where rank<=10