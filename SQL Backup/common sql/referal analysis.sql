 
 ##referal Analysis
 
 ##sign up through referal and conversion rate of referance
 select sum(case when invite_code is not null   then 1 else 0 end ) sign_up_with_referal,  sum(case when invite_code is not null   then 1 else 0 end )/count(*) as ratio,
 sum(case when appointment_count>0 and invite_code is not null then 1 else 0 end )/sum(case when invite_code is not null then 1 else 0 end ) as  conversion_rate_with_referal, 
 sum(case when appointment_count>0 and invite_code is   null   then 1 else 0 end )/sum(case when invite_code is  null   then 1 else 0 end ) as conversion_rate_without_referal
 from 
 (select id,created_at,promo_code,appointment_count from users u where u.kind='client' and created_at>=last_day(now())+interval 1 day-interval 12 month and  created_at<last_day(now())+interval 1 day-interval 1 month)u1 
 left join
(select id,created_at,invite_code from users u where u.kind='client' and invite_code is not null and invite_code<>'' group by invite_code) u2 on u1.promo_code=u2.invite_code



#### sign up without promo
select sum(case when appointment_count>0   then 1 else 0 end )/count(*) as conversion_rate, count(*) sign_up_without_promo_code  
from users 
where kind='client' and (promo_code=''  or promo_code is null)


select id,created_at,promo_code,appointment_count from users u where u.kind='client' and   promo_code<>''  and  promo_code is not null and created_at>=last_day(now())+interval 1 day-interval 12 month and  created_at<last_day(now())+interval 1 day-interval 1 month
 

###convert with referal
 select count(distinct(u1.id))
 
 from 
 (select id,created_at,promo_code,appointment_count from users u where u.kind='client' and   promo_code<>''  and  promo_code is not null and created_at>=last_day(now())+interval 1 day-interval 12 month and  created_at<last_day(now())+interval 1 day-interval 1 month)u1 
join
(select id,created_at,invite_code from users u where u.kind='client' and invite_code is not null and invite_code<>'') u2 on u1.promo_code=u2.invite_code
where appointment_count>0



select distinct(invite_code) from users where invite_code is not null and invite_code<>'' and kind='client'



#####Top 10 Referral Code

select promo_code,sum(total_spend) as total_spend,count(distinct(user_id)) as cnt
from
(select user_id,session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0) as total_spend

from appointment_requests
where status='completed') ar
join  users u on u.id=ar.user_id

where u.kind='client' and u.promo_code in (select distinct(invite_code) from users u where u.kind='client' and invite_code is not null and invite_code<>'')
group by promo_code
order by cnt desc
limit 15








####
select distinct(user_id) from appointment_requests where status='completed'

select appointment_count

from users where kind='client' and id=109
 
 
 
 from 
 (select id,created_at,promo_code,appointment_count from users u where u.kind='client' and   promo_code<>''  and  promo_code is not null )u1 
join
(select id,created_at,invite_code from users u where u.kind='client' and invite_code is not null and invite_code<>'') u2 on u1.promo_code=u2.invite_code
where appointment_count>0





 ### how many people refer other
 select date_format(u2.created_at,'%Y-%m') as date, count(distinct(u2.id)) as referal
 from 
  (select  distinct(promo_code) from users u where u.kind='client' and created_at>=last_day(now())+interval 1 day-interval 7 month and  created_at<last_day(now())+interval 1 day-interval 1 month and   promo_code<>''  and  promo_code is not null )u1 
join
(select id,created_at,invite_code from users u where u.kind='client' and created_at>=last_day(now())+interval 1 day-interval 7 month and  created_at<last_day(now())+interval 1 day-interval 1 month and invite_code is not null and invite_code<>'') u2 on u1.promo_code=u2.invite_code

group by date 
 
 ### booked with referal
 
select  count(distinct(u1.id)) as referal
 from 
  (select  id,promo_code from users u where u.kind='client'  and   promo_code<>''  and  promo_code is not null and appointment_count>0  and created_at>=last_day(now())+interval 1 day-interval 12 month and  created_at<last_day(now())+interval 1 day-interval 1 month)u1 
join
(select distinct(invite_code) from users u where u.kind='client'  and invite_code is not null and invite_code<>'') u2 on u1.promo_code=u2.invite_code



#####






###3 sign up with referall

select  count(distinct(u1.id)) as referal
 from 
  (select  id,promo_code from users u where u.kind='client'  and   promo_code<>''  and  promo_code is not null  and created_at>=last_day(now())+interval 1 day-interval 12 month and  created_at<last_day(now())+interval 1 day-interval 1 month)u1 
join
(select id,created_at,invite_code from users u where u.kind='client'  and invite_code is not null and invite_code<>'') u2 on u1.promo_code=u2.invite_code
 
 select count(*) from users where kind='client'
 
 
 
 
 ##sign ups with promo code
 select sum(case when promo_code is not null and promo_code <>'' then 1 else 0 end) as signup_with_promo, 
 sum(case when promo_code is not null and promo_code <>'' and appointment_count>0 then 1 else 0 end) as converted_with_promo,count(*) as all_signups
 ,sum(case when appointment_count>0 then 1 else 0 end) as all_converted
 
 from users u
 where u.kind='client' and u.created_at>=last_day(now())+interval 1 day -interval 7 month and u.created_at<last_day(now())+interval 1 day -interval 1 month 
 
