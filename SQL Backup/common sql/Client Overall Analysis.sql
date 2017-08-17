select  date_format(session_time,'%Y-%m') as date, sum(deep) as deep,sum(swedish) as swedish,sum(sports) as sports ,sum(prenatal) as prenatal,sum(party) as party,sum(couples) as couples,sum(single) as single,sum(back_to_back) as back_to_back
from
 (select session_time,
 case when (session_type_single='deep' or session_type_double_1='deep' or session_type_double_2='deep') then 1 else 0 end as deep,
 case when (session_type_single='swedish' or session_type_double_1='swedish' or session_type_double_2='swedish') then 1 else 0 end as swedish,
 case when (session_type_single='sports' or session_type_double_1='sports' or session_type_double_2='sports') then 1 else 0 end as sports,
 case when (session_type_single='prenatal' or session_type_double_1='prenatal' or session_type_double_2='prenatal') then 1 else 0 end as prenatal,
 case when (session_type_single='party' or session_type_double_1='party' or session_type_double_2='party') then 1 else 0 end as party,
 case when appointment_type='couples' then 1 else 0 end as couples,
 case when appointment_type='single' then 1 else 0 end as single,
 case when appointment_type='back_to_back' then 1 else 0 end as back_to_back
 from appointment_requests 
 
 where status='completed') a
   group by date
   
   
##### frequency

select avg(deep),avg(swedish),avg(sports), avg(prenatal),avg(party)
from
(
select user_id,timestampdiff(day,u.created_at,now())/a1.deep as deep,timestampdiff(day,u.created_at,now())/a1.swedish as swedish,
timestampdiff(day,u.created_at,now())/a1.sports as sports ,timestampdiff(day,u.created_at,now())/a1.prenatal as prenatal,timestampdiff(day,u.created_at,now())/a1.party as party
from
(select  user_id, sum(deep) as deep,sum(swedish) as swedish,sum(sports) as sports ,sum(prenatal) as prenatal,sum(party) as party
from
 (select user_id,session_time,
 case when (session_type_single='deep' or session_type_double_1='deep' or session_type_double_2='deep') then 1 else 0 end as deep,
 case when (session_type_single='swedish' or session_type_double_1='swedish' or session_type_double_2='swedish') then 1 else 0 end as swedish,
 case when (session_type_single='sports' or session_type_double_1='sports' or session_type_double_2='sports') then 1 else 0 end as sports,
 case when (session_type_single='prenatal' or session_type_double_1='prenatal' or session_type_double_2='prenatal') then 1 else 0 end as prenatal,
 case when (session_type_single='party' or session_type_double_1='party' or session_type_double_2='party') then 1 else 0 end as party
 
 from appointment_requests 
 
 where status='completed') a
   group by user_id) a1
join users u on u.id=a1.user_id
group by user_id)a

#distinct users by session time
select count(distinct(user_id))
from appointment_requests
where status='completed' and (session_type_single='deep' or session_type_double_1='deep' or session_type_double_2='deep')

select count(distinct(user_id))
from appointment_requests
where status='completed' and (session_type_single='swedish' or session_type_double_1='swedish' or session_type_double_2='swedish')

select count(distinct(user_id))
from appointment_requests
where status='completed' and (session_type_single='sports' or session_type_double_1='sports' or session_type_double_2='sports')


select count(distinct(user_id))
from appointment_requests
where status='completed' and (session_type_single='prenatal' or session_type_double_1='prenatal' or session_type_double_2='prenatal')

select count(distinct(user_id))
from appointment_requests
where status='completed' and (session_type_single='party' or session_type_double_1='party' or session_type_double_2='party')

 
 ####
 ## active users YTD
 select count(*) from users where kind='client' and id in ( select user_id from appointment_requests where status='completed' and year(session_time)>=2016 group by user_id)
 
 ###active users
 select count(*) from users where kind='client' and id in ( select user_id from appointment_requests where status='completed'   group by user_id)
##total leads 
select count(*) from users where kind='client'  


#####

 select sum(tx.females) as female,sum(tx.males) as male ,sum(tx.either)as either
 
 from
 (select ar.id,
sum(case when appointment_type='couples' and session_gender_double_1='female' then 1 else 0 end)
+sum(case when appointment_type='couples' and session_gender_double_2='female' then 1 else 0 end)
+sum(case when appointment_type='single' and session_gender_single='female' then 1 else 0 end)
+sum(case when appointment_type='back_to_back' and session_gender_single='female' then 1 else 0 end) as females,	
	
sum(case when appointment_type='couples' and session_gender_double_1='emale' then 1 else 0 end)
+sum(case when appointment_type='couples' and session_gender_double_2='male' then 1 else 0 end)
+sum(case when appointment_type='single' and session_gender_single='male' then 1 else 0 end)
+sum(case when appointment_type='back_to_back' and session_gender_single='male' then 1 else 0 end) 
as males,

sum(case when appointment_type='couples' and session_gender_double_1='either' then 1 else 0 end)
+sum(case when appointment_type='couples' and session_gender_double_2='either' then 1 else 0 end)
+sum(case when appointment_type='single' and session_gender_single='either' then 1 else 0 end)
+sum(case when appointment_type='back_to_back' and session_gender_single='either' then 1 else 0 end) 
as either
		
from appointment_requests ar		
 
 where   status='completed'
 group by id) tx
 
 
####


 select date_format(session_time,'%Y-%m') as date,sum(tx.females) as female,sum(tx.males) as male ,sum(tx.either)as either
 
 from
 (select ar.id,session_time,
sum(case when appointment_type='couples' and session_gender_double_1='female' then 1 else 0 end)
+sum(case when appointment_type='couples' and session_gender_double_2='female' then 1 else 0 end)
+sum(case when appointment_type='single' and session_gender_single='female' then 1 else 0 end)
+sum(case when appointment_type='back_to_back' and session_gender_single='female' then 1 else 0 end) as females,	
	
sum(case when appointment_type='couples' and session_gender_double_1='emale' then 1 else 0 end)
+sum(case when appointment_type='couples' and session_gender_double_2='male' then 1 else 0 end)
+sum(case when appointment_type='single' and session_gender_single='male' then 1 else 0 end)
+sum(case when appointment_type='back_to_back' and session_gender_single='male' then 1 else 0 end) 
as males,

sum(case when appointment_type='couples' and session_gender_double_1='either' then 1 else 0 end)
+sum(case when appointment_type='couples' and session_gender_double_2='either' then 1 else 0 end)
+sum(case when appointment_type='single' and session_gender_single='either' then 1 else 0 end)
+sum(case when appointment_type='back_to_back' and session_gender_single='either' then 1 else 0 end) 
as either
		
from appointment_requests ar		
 
 where   status='completed'
 group by id) tx
 group by date