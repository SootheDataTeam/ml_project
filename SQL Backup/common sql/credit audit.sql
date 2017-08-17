 
 
 ####first time booking
 select date_format(session_time,'%Y-%m') as date,ar.user_id,session_total_price, session_total_price+ifnull(gift_amount,0) as total_spend,ifnull(credit_amount,0) as credit_used,
 case when (ft.id=ar.id and u.promo_code is not null and u.promo_code <>' ') then 'First Booking'
 end as Reason,
 case when ft.id=ar.id and u.promo_code is not null and u.promo_code <>' ' then u.promo_code end as promo_code,session_time as session_time_utc

from appointment_requests ar
join users u on u.id=ar.user_id
join (select user_id,id,min(session_time) from appointment_requests where status='completed' group by user_id) ft on ft.user_id=ar.user_id
 
where ar.status='completed' and year(session_time)=2016 and credit_amount<>0 and  total_spend <> 0



 ### other credit from us
 
select user_id,amount,ct.description
from credits cr
join credit_types ct on ct.id=cr.credit_type_id
where amount>0

##validation
select DATE_FORMAT(session_time,'%Y-%m') as date, sum(credit_amount), avg(credit_amount), count(credit_amount), count(id) 
from appointment_requests

where total_spend <> 0 and credit_amount <> 0  and 
(status='completed') 
group by date
