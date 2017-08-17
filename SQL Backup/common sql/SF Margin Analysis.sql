select u.id, u.email, uwa.credits as unwindme_credits, u.credits as soothe_credits 
from unwindme_accounts uwa
join users u
on uwa.email = u.email
where converted=1



select c.name as city,sum(case when total_spend <>0 and credit_amount<> 0 then 1 else 0 end)/count(*) as discount_ratio,sum(credit_amount) as total_credit_usage,sum(total_spend) as total_spend ,sum(credit_amount)/sum(total_spend) ,sum(case when appointment_type='couples' then 1 else 0 end)/count(*) as couple_ratio

from appointment_requests ar
left join cities c on c.id=ar.city_id

where status='completed'  and c.name is not null and session_time>=last_day(now())+interval 1 day - interval 7 month and session_time<last_day(now())+interval 1 day - interval 1 month
group by city
order by 5 desc
 
 
 


 
 
select c.name,session_length,count(*)

from appointment_requests ar
join cities c on ar.city_id=c.id
where status='completed'  and session_time>=last_day(now())+interval 1 day - interval 7 month and session_time<last_day(now())+interval 1 day - interval 1 month  
group by c.name,session_length


select c.name,session_length,appointment_type,sum(total_spend)/count(*),sum(credit_amount)/count(*),count(*)

from appointment_requests ar
join cities c on ar.city_id=c.id
where status='completed'  and session_time>=last_day(now())+interval 1 day - interval 7 month and session_time<last_day(now())+interval 1 day - interval 1 month  and city_id=3
group by c.name,session_length,appointment_type



###avg spend for 
select c.name,session_length,appointment_type,sum(total_spend)/count(*),sum(credit_amount)/count(*),count(*)
from appointment_requests ar
join cities c on ar.city_id=c.id
where status='completed'  and session_time>=last_day(now())+interval 1 day - interval 7 month and session_time<last_day(now())+interval 1 day - interval 1 month    and city_id=1 
and user_id not  in (select u.id 
from unwindme_accounts uwa
join users u
on uwa.email = u.email
where converted=1)
group by c.name,session_length,appointment_type



select c.name,session_length,appointment_type,sum(  total_spend  )/count(*),sum(credit_amount)/count(*),count(*)
from appointment_requests ar
join cities c on ar.city_id=c.id
where status='completed'  and session_time>=last_day(now())+interval 1 day - interval 7 month and session_time<last_day(now())+interval 1 day - interval 1 month    and city_id=2  

group by c.name,session_length,appointment_type

####

select ar.id,session_length,appointment_type ,total_spend,session_total_price
from appointment_requests ar
join cities c on ar.city_id=c.id
where status='completed'  and session_time>=last_day(now())+interval 1 day - interval 7 month and session_time<last_day(now())+interval 1 day - interval 1 month    and city_id=2   


select * from appointment_requests where status='completed'


#####
select ar.id,session_length,appointment_type ,total_spend,session_total_price
from appointment_requests ar
join cities c on ar.city_id=c.id
where status='completed'  and session_time>=last_day(now())+interval 1 day - interval 7 month and session_time<last_day(now())+interval 1 day - interval 1 month   and city_id=2
order by total_spend desc 

#####

select sum(case when total_spend <> 0 and credit_amount>0 then 1 else 0 end) /count(*) as portion,sum(credit_amount)/sum(total_spend),sum(gift_amount)/sum(total_spend)
from appointment_requests ar
join cities c on ar.city_id=c.id
where status='completed'  and session_time>=last_day(now())+interval 1 day - interval 7 month and session_time<last_day(now())+interval 1 day - interval 1 month   and city_id=1
and user_id not  in (select u.id 
from unwindme_accounts uwa
join users u
on uwa.email = u.email
where converted=1)

 
 
 
 select ar.id,session_length,appointment_type ,total_spend,session_total_price
from appointment_requests ar
join cities c on ar.city_id=c.id
where status='completed'  and session_time>=last_day(now())+interval 1 day - interval 7 month and session_time<last_day(now())+interval 1 day - interval 1 month     and total_spend>338

 #######distribution in SF
 
 select ar.user_id,sum(total_spend) as GMV,sum(total_spend-a.payout)/sum(total_spend) as margin,sum(credit_amount) as credit,count(*) as cnt,sum(a.payout)

from appointment_requests ar

join (select a.appointment_request_id,sum(e.amount) as payout
from appointments a 
join earnings e on e.appointment_id=a.id
where session_time>=last_day(now())+interval 1 day - interval 7 month and session_time<last_day(now())+interval 1 day - interval 1 month  
group by a.appointment_request_id)a  on a.appointment_request_id=ar.id
where ar.status='completed' and ar.session_time>=last_day(now())+interval 1 day - interval 7 month and ar.session_time<last_day(now())+interval 1 day - interval 1 month and city_id=1
group by ar.user_id


 

##### repeat sessions

select sum(case when total_spend<>0 and credit_amount>0 then 1 else 0 end)/count(*), sum(credit_amount)/sum(total_spend),count(*)
from
appointment_requests ar 

where ar.status='completed'and ar.session_time>=last_day(now())+interval 1 day - interval 7 month and ar.session_time<last_day(now())+interval 1 day - interval 1 month and city_id=1 and ar.id   in

(select id from (select user_id,min(session_time) as session_time,id  
from appointment_requests ar
where status='completed' 
group by user_id) ar
where ar.session_time>=last_day(now())+interval 1 day - interval 7 month and ar.session_time<last_day(now())+interval 1 day - interval 1 month and city_id=1
) 

###first sessions
select * from
(select user_id,min(session_time) as session_time  
from appointment_requests ar
where status='completed' 
group by user_id) ar
where ar.session_time>=last_day(now())+interval 1 day - interval 7 month and ar.session_time<last_day(now())+interval 1 day - interval 1 month and city_id=1



###margin for first time user 

 select  sum(total_spend) as GMV,sum(total_spend-a.payout)/sum(total_spend) as margin,sum(credit_amount) as credit,count(*) as cnt

from appointment_requests ar

join (select a.appointment_request_id,sum(e.amount) as payout
from appointments a 
join earnings e on e.appointment_id=a.id
where session_time>=last_day(now())+interval 1 day - interval 8 month and session_time<now()
group by a.appointment_request_id)a  on a.appointment_request_id=ar.id
where ar.status='completed' and ar.session_time>=last_day(now())+interval 1 day - interval 7 month and ar.session_time<last_day(now())+interval 1 day - interval 1 month and city_id=1 and
ar.id     in (select id from (select user_id,min(session_time) as session_time,id  
from appointment_requests ar
where status='completed' 
group by user_id) ar
where ar.session_time>=last_day(now())+interval 1 day - interval 7 month and ar.session_time<last_day(now())+interval 1 day - interval 1 month and city_id=1)


