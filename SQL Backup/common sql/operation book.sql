
###sign ups
 ## sign up platform
 select u1.date,u1.type,u1.cnt/u2.cnt as ratio
 from 
 (select date_format(created_at,'%Y-%m') as date,case when signup_type='mobile' THEN 'Mobile App'
	 when signup_type='web' AND 
	 (signed_up_platform IN ('iPad','iPhone', 'Windows') OR signed_up_platform like '%Android%') THEN 'Mobile Web'
	 else 'Web' END as Type
 ,count(*) as cnt from users where kind='client' and year(created_at)>=2014
 
 group by date,type) u1
join  
 (select  date_format(created_at,'%Y-%m') as date,count(*) as cnt  from users where kind='client'
 
 group by date) u2 on u1.date=u2.date
 group by u1.date,u1.type
 
 
 ##referal ratio
 
 ##sign up through referal and conversion rate of referance
 select date_format(u1.created_at,'%Y-%m') as date,sum(case when promo_code is not null   then 1 else 0 end ) sign_up_with_referal,  sum(case when promo_code is not null   then 1 else 0 end )/count(*) as ratio,
 sum(case when appointment_count>0 and promo_code is not null then 1 else 0 end )/sum(case when promo_code is not null then 1 else 0 end ) conversion_rate_with_referal, 
 sum(case when appointment_count>0 and promo_code is   null   then 1 else 0 end )/sum(case when promo_code is  null   then 1 else 0 end ) conversion_rate_without_referal
 from 
 (select id,created_at,promo_code,appointment_count from users u where u.kind='client' and year(created_at)>=2014)u1 
 left join
(select id,created_at,invite_code from users u where u.kind='client' and year(created_at)>=2014 and invite_code is not null and invite_code<>'') u2 on u1.promo_code=u2.invite_code

group by date
 ### how many people refer other
 select date_format(u1.created_at,'%Y-%m') as date, count(distinct(u1.id)) as referal
 from 
  (select id,created_at,promo_code,appointment_count from users u where u.kind='client' and year(created_at)>=2014)u1 
join
(select id,created_at,invite_code from users u where u.kind='client' and year(created_at)>=2014 and invite_code is not null and invite_code<>'') u2 on u1.promo_code=u2.invite_code

group by date 
 
 
 
###gender 
 
select sum(case when gender='male' then 1 else 0) /count(*) as male_ratio, sum(case when gender='female' then 1 else 0) /count(*) as from users where kind='client' and gender is not null



####conversion%
#conversion% by time
select date_format(created_at,'%Y-%m') as date,count(*) as cnt_leads,sum(case when appointment_count>0 then 1 else  0 end )/count(*) as conversion_ratio
 from users where kind='client'  and year(created_at)>=2014 and created_at is not null 
 group by date
 
## conversion% sign up with or without promo code
select date_format(created_at,'%Y-%m') as date,sum(case when appointment_count>0 and promo_code is not null then 1 else 0 end) as booekers_with_credit,sum(case when appointment_count>0 and promo_code is not null then 1 else 0 end)/sum(case when promo_code is not null then 1 else 0 end) as conversion_with_credit,
sum(case when appointment_count>0 and promo_code is  null then 1 else 0 end) as booekers_without_credit,sum(case when appointment_count>0 and promo_code is null then 1 else 0 end )/sum(case when promo_code is null then 1 else 0 end) as conversion_without_credit
from users where kind='client'  and year(created_at)>=2014 and created_at is not null  
group by date


##
###probability from fisrt time client to repeat client (by first  booking type)
(select 
date_format(first_session,'%Y-%m') as date,sum(case when appointment_count=1 then 1 else 0 end) as rep, count(*) as cnt,sum(case when appointment_count=1 then 1 else 0 end)/ count(*) as ratio
from users u
join
(select user_id,min(session_time) as first_session

from appointment_requests ar
where ar.status='completed' and total_spend <>0 and (credit_amount= 0 or credit_amount is null)
group by user_id) ar on ar.user_id=u.id

group by date) d1  

join 
(select 
date_format(first_session,'%Y-%m') as date,sum(case when appointment_count>1 then 1 else 0 end) as rep, count(*) as cnt,sum(case when appointment_count>1 then 1 else 0 end)/ count(*) as ratio
from users u
join
(select user_id,min(session_time) as first_session

from appointment_requests ar
where ar.status='completed' and total_spend <>0 and credit_amount<> 0 and credit_amount is not null
group by user_id) ar on ar.user_id=u.id

group by date) d2 d1.date=d2.date






 ######booking behaviour
 #### growth% for first time and repeat client(this could by city)
 
select date_format(session_time,'%Y-%m') as date, case ar.session_time when j.tm then 'FT' else 'Repeat' end as first,c.name
from appointment_requests ar
 left join cities c on c.id=ar.city_id
left join(select user_id, min(session_time) as tm from appointment_requests where status ='completed' group by user_id) as j on j.user_id = ar.user_id
where ar.status='completed' and year(ar.session_time)>=2014



####booking seasonality(by city)
select c.name,case when month(session_time) in (3,4,5) then 'Spring'
 when month(session_time) in (6,7,8) then 'Summer'
 when month(session_time) in (9,10,12) then 'Fall'
 else 'Winter' end as season,count(*)/ (select count(*) from appointment_requests where status='completed' and year(session_time)>=2014) as ratio
 
 from appointment_requests ar 
 left join cities c on c.id=ar.city_id
 where status='completed' and year(session_time)>=2014
 
 group by c.name,season

 
 ###RFM analysis(by city)
 
 select date_format(created_at,'%Y-%m') as date,ar.city,avg(money_spent) as avg_spending,avg(timestampdiff(day,created_at,now())/appointment_count) as freq_day, 
 avg(timestampdiff(day,latest_booking,now())) as lastest_booking ,avg(timestampdiff(day,created_at,first_booking)) as interval_between_signup_firstbooking
 from users u
 join( select user_id,min(session_time) as first_booking,c.name as city from appointment_requests ar 
 join cities c on c.id=ar.city_id where status='completed' group by user_id)ar  on ar.user_id= u.id
 join( select user_id,max(session_time) as latest_booking,c.name as city from appointment_requests ar 
 join cities c on c.id=ar.city_id where status='completed'  group by user_id having max(session_time)<=now())ar2  on ar2.user_id= u.id
 where kind='client' and year(created_at)>=2014 and appointment_count is not null
 group by ar.city,date
 


### portion of GMV contribution(by city by time) 
select ar1.date, ar1.city, ar1.gmv/ar2.gmv
from
(select date_format(session_time,'%Y-%m') as date,c.name as city,sum(total_spend) as gmv from appointment_requests ar

join cities c on c.id=ar.city_id
where ar.status='completed' and year(session_time)>=2014

 group by date,city) ar1 
 
 join (select date_format(session_time,'%Y-%m') as date, sum(total_spend) as gmv from appointment_requests ar
where ar.status='completed'and year(session_time)>=2014

  group by date) ar2 on ar1.date=ar2.date
 
 group by ar1.date,ar1.city
 
 
### cancellation analysis
#how likely clients would cancelled the apt
 select  date_format(session_time,'%Y-%m') as date,c.name as city,sum(case when cancel.cancell_by='cancelled by client' then 1 else 0 end)as cancelled_by_client_cnt,  sum(case when cancel.cancell_by='cancelled by client' then 1 else 0 end)/count(*) 
 from appointment_requests ar
  join
  (select appointment_request_id,cancellation_type_id,cancell_by from cancellations c
  join(select id,case when slug like "%cancelled_by_client%" or slug like '%client_error%' then 'cancelled by client' else slug end as cancell_by  from cancellation_types) ct on ct.id=c.cancellation_type_id)cancel on cancel.appointment_request_id=ar.id
  join cities c on c.id=ar.city_id
 
 where year(session_time)>=2014
 
group by  date,city

#### cancel_freq
select ar2.city,avg(cnt_request/cnt_cancelled) as cancel_freq 
from 
(select user_id,count(*) as cnt_request from appointment_requests ar where year(session_time)>=2014 group by user_id) ar1
join
 (select  user_id,c.name as city ,count(*) cnt_cancelled
 from appointment_requests ar
  join
  (select appointment_request_id,cancellation_type_id,cancell_by from cancellations c
  join(select id,case when slug like "%cancelled_by_client%" or slug like '%client_error%' then 'cancelled by client' else slug end as cancell_by  from cancellation_types) ct on ct.id=c.cancellation_type_id)cancel on cancel.appointment_request_id=ar.id
  join cities c on c.id=ar.city_id
 
 where year(session_time)>=2014 and cancel.cancell_by='cancelled by client'
 group by user_id) ar2 on ar1.user_id=ar2.user_id
 group by ar2.city

 
 ####client rating
 
 select * from users where kind='client'
 
 ###probability from first bookers to repeat bookers (by city )
 select ar.city,sum(case when appointment_count>1 then 1 else 0 end )/count(*) as repeat_prob
 from users u
 join
 (select user_id, min(session_time),c.name as city
 from appointment_requests ar
 join cities c on c.id=ar.city_id
 where ar.status='completed' group by user_id) ar on ar.user_id=u.id
 where u.kind='client' and year(created_at)>=2014
 group by ar.city
 
 
 ###probability from first bookers to repeat bookers (by city by time)
 
 select date_format(created_at,'%Y-%m') as date,ar.city,sum(case when appointment_count>1 then 1 else 0 end )/count(*) as repeat_prob
 from users u
 join
 (select user_id, min(session_time),c.name as city
 from appointment_requests ar
 join cities c on c.id=ar.city_id
 where ar.status='completed' group by user_id) ar on ar.user_id=u.id
 where u.kind='client' and year(created_at)>=2014
 group by date, ar.city
 
 #### first booking cancelled how likely to book the first session (by city)
select cu.city,sum(case when appointment_count>0 then 1 else 0 end )/count(*) as first_prob,sum(case when appointment_count>0 then 1 else 0 end ),count(*)
 from users u
 join
 (select ar.user_id,ar.city
 from
 (select user_id, min(session_time) as first_time,status,ar.id,c.name as city from appointment_requests ar join cities c on c.id=ar.city_id where status in ('completed','cancelled') group by user_id) ar
 where ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) cu on cu.user_id=u.id
where u.kind='client' and year(created_at)>=2014
group by cu.city 
 
 
 #### first booking cancelled how likely to book the first session (by city by time)
 select date_format(created_at,'%Y-%m') as date,cu.city,sum(case when appointment_count>0 then 1 else 0 end )/count(*) as repeat_prob
 from users u
 join
 (select ar.user_id,ar.city
 from
 (select user_id, min(session_time) as first_time,status,ar.id,c.name as city from appointment_requests ar join cities c on c.id=ar.city_id group by user_id) ar
 where ar.status='cancelled' and ar.id in (select id
 from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) cu on cu.user_id=u.id
where u.kind='client' and year(created_at)>=2014
 group by date, cu.city 
 
 
 

 ### for repeat bookers  session cancelled how likely to book another(by city)
 
 set @group='', @row = 0;
 

select c.city,sum(case when ar.last_booking>cl.session_time and rank=1 then 1 else 0 end)/sum(case when rank=1 then 1 else 0 end) as booking_ratio_cancelled_1st, 
sum(case when ar.last_booking>cl.session_time and rank=2 then 1 else 0 end)/sum(case when rank=2 then 1 else 0 end) as booking_ratio_cancelled_2nd,
sum(case when ar.last_booking>cl.session_time and rank=3 then 1 else 0 end)/sum(case when rank=3 then 1 else 0 end) as booking_ratio_cancelled_3rd,
sum(case when ar.last_booking>cl.session_time and rank=4 then 1 else 0 end)/sum(case when rank=4 then 1 else 0 end) as booking_ratio_cancelled_4th
from
(select user_id, max(session_time) as last_booking from appointment_requests where status='completed' group by user_id) ar
join
(select user_id,rank,session_time
from
 (select user_id,@row:=if(@group=user_id,@row+1,1) as rank, @group:=user_id,session_time
 from appointment_requests ar
 where ar.status='cancelled' and ar.id in (select id
 from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc)  
order by user_id,session_time) ar 
where rank<=4
) cl on cl.user_id=ar.user_id 

join (select user_id, min(session_time),c.name as city from appointment_requests ar join cities c on c.id=ar.city_id where status='completed' group by user_id ) c on c.user_id=ar.user_id
 group by  c.city
 



 
 ####financial 
 
#### LTV spending(city)
 select tx.*, early.name
from (
Select ar.user_id, count(*) as booking_count, sum(ar.total_spend), sum(ar.session_total_price), year(ar.session_time), month(ar.session_time), 
(month(ar.session_time) + (year(ar.session_time) * 12) - (2013 * 12) - 7) as session_mo_offset, ua.first_active_at_mo, 
ua.first_active_at_yr, (year(ar.session_time) * 12 + month(ar.session_time)) - (ua.first_active_at_yr * 12 +  ua.first_active_at_mo)   as cohort_month, 
(ua.first_active_at_mo + (ua.first_active_at_yr * 12) - (2013 * 12) - 7) as activation_month, (billing_state = customer_state) as is_local, 
weekday(ar.session_time) as weekday
from appointment_requests ar
join (
select u.id, u.signup_type, count(*) as ar_count,
u.created_at, month(u.created_at) as created_at_mo, year(u.created_at) as created_at_yr, 
min(ar.created_at) as first_active_at, month(min(ar.created_at)) as first_active_at_mo, year(min(ar.created_at)) as first_active_at_yr,dayname(min(ar.created_at)) as sign_up_day, hour(min(ar.created_at)) as sign_up_hour
from users u
join appointment_requests ar
on ar.user_id = u.id
where u.kind = 'client' and (ar.status ='completed') 
group by u.id
) as ua
on ar.user_id = ua.id
where (ar.status ='completed') 
group by ar.user_id, year(ar.session_time), month(ar.session_time)
order by year(ar.session_time) asc, month(ar.session_time) asc
) as tx
left join

(select user_id, min(session_time) as mintime,ar.city_id,c.name
from appointment_requests ar
left join(select id, name
    from cities c) as c
    on ar.city_id = c.id
where ar.status = 'completed'
group by user_id) as early on early.user_id=tx.user_id
 
 
 ### LTV Margin (city)
 
 
select tx.*
from
(Select ar.user_id, count(*) as booking_count, sum(e.payout), year(ar.session_time), month(ar.session_time), 
(month(ar.session_time) + (year(ar.session_time) * 12) - (2013 * 12) - 7) as session_mo_offset, ua.first_active_at_mo, 
ua.first_active_at_yr, (year(ar.session_time) * 12 + month(ar.session_time)) - (ua.first_active_at_yr * 12 +  ua.first_active_at_mo)   as cohort_month, 
(ua.first_active_at_mo + (ua.first_active_at_yr * 12) - (2013 * 12) - 7) as activation_month, 
weekday(ar.session_time) as weekday,sign_up_day
from appointments ar
join (
select u.id, u.signup_type, count(*) as ar_count,
u.created_at, month(u.created_at) as created_at_mo, year(u.created_at) as created_at_yr, 
min(ar.created_at) as first_active_at, month(min(ar.created_at)) as first_active_at_mo, year(min(ar.created_at)) as first_active_at_yr,dayname(min(ar.created_at)) as sign_up_day
from users u
join appointments ar
on ar.user_id = u.id
where u.kind = 'client' and (ar.status ='complete' or ar.status='reviewed') 
group by u.id
) as ua
on ar.user_id = ua.id
join (select e.appointment_id,sum(e.amount) as payout from earnings e
group by e.appointment_id) e on e.appointment_id=ar.id
where (ar.status ='complete' or ar.status='reviewed') 
group by ar.user_id, year(ar.session_time), month(ar.session_time)
order by year(ar.session_time) asc, month(ar.session_time) asc) as tx
 
 
 
 
 
 ### CAC
 
 
 
 
 
 
 
 
 
 
 
 

  
  
  
