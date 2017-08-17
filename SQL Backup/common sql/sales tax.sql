
set @x1='2017-02-01 00:00';

select ar.id,date_format(session_time,'%Y-%m') as date,c.name as city,session_total_price,session_subtotal_price,round(session_subtotal_price*ifnull(sc.rate,0)/100,2) as sales_tax,ifnull(surcharge_amount,0),ifnull(credit_amount,0),ifnull(gift_amount,0),case ar.session_time when j.tm then 'FT' else 'Repeat' end as first
from appointment_requests ar
left join (select city_id,rate from  city_surcharges where active=1) sc on sc.city_id=ar.city_id
join cities c on c.id=ar.city_id
left join(select user_id, min(session_time) as tm from appointment_requests where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id

where status='completed' and session_time>=@x1
having sales_tax>0




########
select city_id from appointment_requests where id=2604943
select * from city_surcharges where city_id=52

select cs.*,c.name as city from city_surcharges cs
join cities c on c.id=cs.city_id
 where cs.active=1


select sum(surcharge_amount) from appointment_requests

where date_format(session_time,'%Y-%m')='2017-02' and status='completed'

select ar.id,ifnull((select calculated_amount from surcharges s join city_surcharges cs on cs.id=s.city_surcharge_id  where appointment_request_id=ar.id and cs.active=1),0) as sales_tax
from appointment_requests ar
where ar.status='completed' and date_format(session_time,'%Y-%m')='2017-02'
having sales_tax>0

select * from city_surcharges