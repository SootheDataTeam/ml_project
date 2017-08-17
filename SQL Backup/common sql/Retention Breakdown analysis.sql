







 
 ############## 1st retention% by city
 select a2.date_first,a2.city,a2.first_timer,7_day,14_day,30_day, 60_day, 90_day, 7_day/a2.first_timer as 7_day_ratio,14_day/a2.first_timer as 14_day_ratio,30_day/a2.first_timer as 30_day_ratio
 ,60_day/a2.first_timer as 60_day_ratio ,90_day/a2.first_timer as 90_day_ratio
 from
 
 (
select  ar1.date_first,m.city,count(*) as first_timer

from
(select user_id,min(ar.created_at) as first_created,date_format(min(ar.created_at),'%Y-%m') as date_first

from appointment_requests ar
 

where status='completed'
group by user_id)ar1
join (select user_id,city from
 (select user_id,count(*) as cnt,c.name as city from appointment_requests ar join cities c on c.id=ar.city_id 
 where status='completed' group by user_id,city order by cnt desc)a group by user_id) m on m.user_id=ar1.user_id  
 
 where year(ar1.first_created)=2016
group by ar1.date_first,m.city

) a2
 
 
 left join
 
 (select  date_first,city,sum(case when   timestampdiff(day, first_created,created)<7  then 1 else 0 end) as 7_day,
sum(case when timestampdiff(day,first_created,created)<14 then 1 else 0 end) as 14_day,
sum(case when timestampdiff(day,first_created,created)<30 then 1 else 0 end) as 30_day,
sum(case when timestampdiff(day,first_created,created)<60 then 1 else 0 end) as 60_day,
sum(case when timestampdiff(day,first_created,created)<90 then 1 else 0 end) as 90_day
 from
 (select ar.user_id,min(created_at) as created ,ar1.first_created,m.city,date_first
 
 from appointment_requests ar


join (select user_id,city from
 (select user_id,count(*) as cnt,c.name as city from appointment_requests ar join cities c on c.id=ar.city_id 
 where status='completed' group by user_id,city order by cnt desc)a group by user_id) m on m.user_id=ar.user_id
join 
(select user_id,min(ar.created_at) as first_created,date_format(min(ar.created_at),'%Y-%m') as date_first

from appointment_requests ar
 

where status='completed'
group by user_id)ar1  on ar.user_id=ar1.user_id
where  ar.created_at >ar1.first_created and year(ar1.first_created)=2016 and ar.status='completed'
group by ar.user_id) a

group by date_first,city)a1 on a1.date_first=a2.date_first and a1.city=a2.city
 

######modified by MT


 
select a2.therapist_id,concat(u.first_name,' ',u.last_name) as name,a2.date_first,a2.first_timer,ifnull(7_day,0) as 7_day,ifnull(14_day,0) as 14_day,ifnull(30_day,0) as 30_day, ifnull(60_day,0) as 60_day, ifnull(90_day,0) as 90_day, ifnull(7_day,0)/a2.first_timer as 7_day_ratio,ifnull(14_day,0)/a2.first_timer as 14_day_ratio,ifnull(30_day,0)/a2.first_timer as 30_day_ratio,
 ifnull(60_day,0)/a2.first_timer as 60_day_ratio ,ifnull(90_day,0)/a2.first_timer as 90_day_ratio
from
(select therapist_id,date_first,count(*) as  first_timer
from
(select ar.user_id,a.therapist_id,min(ar.created_at) as first_created ,date_format(min(ar.created_at),'%Y-%m') as date_first

from appointments a

join appointment_requests ar on ar.id=a.appointment_request_id

where a.status in ('complete','reviewed') 

group by ar.user_id) a

 where year(first_created)=2016
group by therapist_id,date_first) a2
join users u on u.id=a2.therapist_id
 


left join 
(select 
 therapist_id,date_first,sum(case when   timestampdiff(day, first_created,created)<7  then 1 else 0 end) as 7_day,
sum(case when timestampdiff(day,first_created,created)<14 then 1 else 0 end) as 14_day,
sum(case when timestampdiff(day,first_created,created)<30 then 1 else 0 end) as 30_day,
sum(case when timestampdiff(day,first_created,created)<60 then 1 else 0 end) as 60_day,
sum(case when timestampdiff(day,first_created,created)<90 then 1 else 0 end) as 90_day


from
(select ar.user_id,ar1.therapist_id,min(created_at) as created ,ar1.first_created, date_first

from appointment_requests ar

join 
(select ar.user_id,a.therapist_id,min(ar.created_at) as first_created ,date_format(min(ar.created_at),'%Y-%m') as date_first

from appointments a

join appointment_requests ar on ar.id=a.appointment_request_id

where a.status in ('complete','reviewed') 

group by ar.user_id) ar1 on ar1.user_id=ar.user_id

where  ar.created_at >ar1.first_created and year(ar1.first_created)=2016 and ar.status='completed'

group by ar.user_id) a
group by  therapist_id,date_first) a1  on a1.therapist_id=a2.therapist_id  and a1.date_first=a2.date_first


#####1st retention by zip code 
 select a2.date_first,a2.customer_zip,a2.first_timer,ifnull(7_day,0) as 7_day,ifnull(14_day,0) as 14_day,ifnull(30_day,0) as 30_day, ifnull(60_day,0) as 60_day, ifnull(90_day,0) as 90_day, ifnull(7_day,0)/a2.first_timer as 7_day_ratio,ifnull(14_day,0)/a2.first_timer as 14_day_ratio,ifnull(30_day,0)/a2.first_timer as 30_day_ratio,
 ifnull(60_day,0)/a2.first_timer as 60_day_ratio ,ifnull(90_day,0)/a2.first_timer as 90_day_ratio
 from
 (
select  ar1.date_first,m.customer_zip,count(*) as first_timer

from
(select user_id,min(ar.created_at) as first_created,date_format(min(ar.created_at),'%Y-%m') as date_first

from appointment_requests ar
 

where status='completed'
group by user_id)ar1
join (select user_id,customer_zip from
 (select user_id,count(*) as cnt,customer_zip from appointment_requests ar
 where status='completed' group by user_id,customer_zip order by cnt desc)a group by user_id) m on m.user_id=ar1.user_id  
 
 where year(ar1.first_created)=2016
group by ar1.date_first,m.customer_zip

) a2
 
 left join
 

 (select  date_first,customer_zip,sum(case when   timestampdiff(day, first_created,created)<7  then 1 else 0 end) as 7_day,
sum(case when timestampdiff(day,first_created,created)<14 then 1 else 0 end) as 14_day,
sum(case when timestampdiff(day,first_created,created)<30 then 1 else 0 end) as 30_day,
sum(case when timestampdiff(day,first_created,created)<60 then 1 else 0 end) as 60_day,
sum(case when timestampdiff(day,first_created,created)<90 then 1 else 0 end) as 90_day
 from
 (select ar.user_id,min(created_at) as created ,ar1.first_created,m.customer_zip,date_first
 
 from appointment_requests ar


join (select user_id,customer_zip from
 (select user_id,count(*) as cnt,customer_zip from appointment_requests ar 
 where status='completed' group by user_id,customer_zip order by cnt desc)a group by user_id) m on m.user_id=ar.user_id
join 
(select user_id,min(ar.created_at) as first_created,date_format(min(ar.created_at),'%Y-%m') as date_first

from appointment_requests ar
 

where status='completed'
group by user_id)ar1  on ar.user_id=ar1.user_id
where  ar.created_at >ar1.first_created and year(ar1.first_created)=2016 and ar.status='completed'
group by ar.user_id) a

group by date_first,customer_zip)a1 on a1.date_first=a2.date_first and a1.customer_zip=a2.customer_zip









#######################
#Overall retention% 
#######################



#####overall by city

select city,date,count(*) as first_time,sum(7_d),sum(14_d),sum(30_d),sum(60_d),sum(90_d),sum(7_d)/count(*) as 7_day_ratio,sum(14_d)/count(*) as 14_day_ratio,sum(30_d)/count(*) as 30_day_ratio,sum(60_d)/count(*) as 60_day_ratio,sum(90_d)/count(*) as 90_day_ratio
from
(select ar1.user_id, DATE_FORMAT(ar1.created_at,'%Y-%m') as date,max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<7) then 1 else 0 end) as 7_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<14) then 1 else 0 end) as 14_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<30) then 1 else 0 end) as 30_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<60) then 1 else 0 end) as 60_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<90) then 1 else 0 end) as 90_d
from appointment_requests ar1

where status='completed' and year(created_at)=2016  
group by ar1.user_id,date)a

  join (select user_id,city from (select user_id,count(*) as cnt,c.name as city from appointment_requests ar join cities c on c.id=ar.city_id where status='completed' group by user_id,city order by cnt desc)a group by user_id) m on m.user_id=a.user_id
  group by city,date





#####overall by therapist

select a.therapist_id,concat(u.first_name,' ',last_name) as name,date,count(*) as first_time,sum(7_d),sum(14_d),sum(30_d),sum(60_d),sum(90_d),sum(7_d)/count(*) as 7_day_ratio,sum(14_d)/count(*) as 14_day_ratio,sum(30_d)/count(*) as 30_day_ratio,sum(60_d)/count(*) as 60_day_ratio,sum(90_d)/count(*) as 90_day_ratio
from
(select a.therapist_id,ar1.user_id, DATE_FORMAT(ar1.created_at,'%Y-%m') as date,max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<7) then 1 else 0 end) as 7_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<14) then 1 else 0 end) as 14_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<30) then 1 else 0 end) as 30_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<60) then 1 else 0 end) as 60_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<90) then 1 else 0 end) as 90_d
from appointment_requests ar1
join appointments a on a.appointment_request_id=ar1.id

where ar1.status='completed' and a.status in ('complete','reviewed') and year(ar1.created_at)=2016  
group by a.therapist_id,ar1.user_id,date)a
join users u on u.id=a.therapist_id
  
  group by therapist_id,date

#########overall by zip code 


select customer_zip,date,count(*) as first_time,sum(7_d),sum(14_d),sum(30_d),sum(60_d),sum(90_d),sum(7_d)/count(*) as 7_day_ratio,sum(14_d)/count(*) as 14_day_ratio,sum(30_d)/count(*) as 30_day_ratio,sum(60_d)/count(*) as 60_day_ratio,sum(90_d)/count(*) as 90_day_ratio
from
(select ar1.user_id, DATE_FORMAT(ar1.created_at,'%Y-%m') as date,max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<7) then 1 else 0 end) as 7_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<14) then 1 else 0 end) as 14_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<30) then 1 else 0 end) as 30_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<60) then 1 else 0 end) as 60_d,
max(case when ar1.user_id in (select user_id from appointment_requests ar where status='completed' and ar.user_id=ar1.user_id and ar.created_at>ar1.created_at and TIMESTAMPDIFF(day,ar1.created_at,ar.created_at)<90) then 1 else 0 end) as 90_d
from appointment_requests ar1

where status='completed' and year(created_at)=2016  
group by ar1.user_id,date)a

  join (select user_id,customer_zip from (select user_id,count(*) as cnt,customer_zip from appointment_requests ar where status='completed' group by user_id,customer_zip order by cnt desc)a group by user_id) m on m.user_id=a.user_id
  group by customer_zip,date





  