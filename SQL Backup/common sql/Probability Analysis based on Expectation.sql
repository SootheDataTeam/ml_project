#####
select sum(case when appointment_count>0 then 1 else 0 end ) as bookers, count(*) as cnt, sum(case when appointment_count>0 then 1 else 0 end )/count(*) as ratio
from users u
 
where kind='client' and year(u.created_at)>=2014 and promo_code is not null


#####

select *
from 
users u
left join ( 
select ar.user_id, max(credit_amount), count(*)
from appointment_requests ar
where ar.is_repeat = false
and status='completed'
group by ar.user_id
) as first_booking_credit
on u.id = first_booking_credit.user_id


#####

select sum(case when appointment_count>0  then 1 else 0 end ) as bookers, count(*) as cnt, sum(case when appointment_count>0 then 1 else 0 end )/count(*) as ratio
from users u

where kind='client' and year(u.created_at)>=2014 and (promo_code is null)


#avg of first booking 
#with discount

select  avg

select user_id, min(session_time),total_spend from appointment_requests where status='completed' and 


###
select 
date_format(first_session,'%Y-%m') as date,sum(case when appointment_count=1 then 1 else 0 end) as rep, count(*) as cnt,sum(case when appointment_count=1 then 1 else 0 end)/ count(*) as ratio
from users u
join
(select user_id,min(session_time) as first_session

from appointment_requests ar
where ar.status='completed' and total_spend <>0 and (credit_amount= 0 or credit_amount is null)
group by user_id) ar on ar.user_id=u.id

group by date

####

select 
date_format(first_session,'%Y-%m') as date,sum(case when appointment_count>1 then 1 else 0 end) as rep, count(*) as cnt,sum(case when appointment_count>1 then 1 else 0 end)/ count(*) as ratio
from users u
join
(select user_id,min(session_time) as first_session

from appointment_requests ar
where ar.status='completed' and total_spend <>0 and credit_amount<> 0 and credit_amount is not null
group by user_id) ar on ar.user_id=u.id

group by date


## no booking for client with credit
select * from users where (credits >0) and kind='client' and (appointment_count=0 or appointment_count is null)


####no booking for client do not have credit

select count(*) from users where (credits =0) and kind='client' and (appointment_count=0 or appointment_count is null) and id not in(select user_id from (select user_id,min(session_time) as first_session

from appointment_requests ar
where ar.status='completed' and total_spend <>0 and credit_amount<> 0 and credit_amount is not null
group by user_id) f 
) 


### avg profit for client with discount
select avg(ar.total_spend-p.payout) as avg_profit
from 
(select user_id, min(session_time),id,total_spend from appointment_requests where status='completed' and total_spend <>0 and credit_amount<> 0 and credit_amount is not null group by user_id) ar 

join ( select a.appointment_request_id,sum(e.amount)  as payout
from appointments a 
join earnings e on e.appointment_id=a.id
group by a.appointment_request_id ) p on p.appointment_request_id=ar.id

### avg profit for client without discount

select avg(ar.total_spend-p.payout) as avg_profit
from 
(select user_id, min(session_time),id,total_spend from appointment_requests where status='completed' and total_spend <>0 and (credit_amount= 0 or credit_amount is null) group by user_id) ar 

join ( select a.appointment_request_id,sum(e.amount)  as payout
from appointments a 
join earnings e on e.appointment_id=a.id
group by a.appointment_request_id ) p on p.appointment_request_id=ar.id



#### other booking with discount
select avg(ar.total_spend-p.payout) as avg_profit
from (select user_id,id,total_spend from appointment_requests where status='completed' and year(session_time)>=2014) ar 

join ( select a.appointment_request_id,sum(e.amount)  as payout
from appointments a 
join earnings e on e.appointment_id=a.id
group by a.appointment_request_id ) p on p.appointment_request_id=ar.id

where user_id in (select user_id from (select user_id, min(session_time),id,total_spend from appointment_requests where status='completed' and total_spend <>0 and credit_amount<> 0 and credit_amount is not null group by user_id)f) and id not in 
(select id from (select user_id, min(session_time),id,total_spend from appointment_requests where status='completed' and total_spend <>0 and credit_amount<> 0 and credit_amount is not null group by user_id)f)
###other booking without discount

select avg(ar.total_spend-p.payout) as avg_profit
from (select user_id,id,total_spend from appointment_requests where status='completed' and year(session_time)>=2014) ar 

join ( select a.appointment_request_id,sum(e.amount)  as payout
from appointments a 
join earnings e on e.appointment_id=a.id
group by a.appointment_request_id ) p on p.appointment_request_id=ar.id

where user_id in (select user_id from (select user_id, min(session_time),id,total_spend from appointment_requests where status='completed' and total_spend <>0  and (credit_amount= 0 or credit_amount is null) group by user_id)f) and id not in 
(select id from (select user_id, min(session_time),id,total_spend from appointment_requests where status='completed' and total_spend <>0  and (credit_amount= 0 or credit_amount is null) group by user_id)f)



