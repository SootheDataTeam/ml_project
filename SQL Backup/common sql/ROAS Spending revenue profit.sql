 set @x1 = '2016-02-01 00:00', @x2 = '2016-10-10 00:00';

select m.date,spending,revenue_7,revenue_7/spending as ROAS_7,revenue_14,revenue_14/spending as ROAS_14,revenue_30,revenue_30/spending as ROAS_30, profit_7,profit_7/spending as ROAS_7_profit,profit_14,profit_14/spending as ROAS_14_profit ,profit_30,profit_30/spending as ROAS_30_profit
from
(select date_format(u.created_at,'%Y-%m')as date ,sum(case when timestampdiff(day,created_at,session_time)<7 then p_spend else 0 end) as revenue_7,
sum(case when timestampdiff(day,created_at,session_time)<14 then p_spend else 0 end) as revenue_14,
sum(case when timestampdiff(day,created_at,session_time)<30 then p_spend else 0 end) as revenue_30,

sum(case when timestampdiff(day,created_at,session_time)<7 then p_spend-payout else 0 end) as profit_7,
sum(case when timestampdiff(day,created_at,session_time)<14 then p_spend-payout else 0 end) as profit_14,
sum(case when timestampdiff(day,created_at,session_time)<30 then p_spend-payout else 0 end) as profit_30
from
(select ar.user_id,session_total_price+ifnull(gift_amount,0)  as p_spend,session_time,id

from appointment_requests ar
where ar.status='completed' 
) ar
join users u on u.id=ar.user_id
join (
select appointment_request_id,sum(e.amount) as payout
from appointments a
join earnings e on e.appointment_id=a.id
group by appointment_request_id)  p on p.appointment_request_id=ar.id
where u. kind='client' and u.created_at>=@x1 and u.created_at<=@x2

group by date)ar

join (select date_format(day,'%Y-%m')as date,sum(cost) as spending
from marketing_spendings 
group by date
) m on m.date=ar.date