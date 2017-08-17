set @yr=2017,@mo=1;

select credit_type,sum(credit_amount) as free_Massage_credit_amount,sum(earnings) as Free_massage_cost
from
(select  a.id,case when ct.description is not null then ct.description else 'Other' end as credit_type,credit_amount,earnings
from
(select ar.id,ar.user_id,credit_amount,earnings
from appointment_requests ar

join (select ar.id as ar_id, a.id, sum(e.amount) as earnings
from appointment_requests ar
 join appointments a
on a.appointment_request_id = ar.id
 join earnings e
on e.appointment_id = a.id
where ar.status = 'completed'
group by ar.id) as tx2
on tx2.ar_id = ar.id
join users u
on ar.user_id = u.id
left join (
select code, value from promo_codes where uses > 0
) as p
on u.promo_code = p.code
left join (
select recipient_email, sum(amount) as amount 
from gift_certificates
where (stripeToken is not null or credit_card_id is not null) and used=1
group by recipient_email
) as g
on u.email=g.recipient_email

where ar.status='completed' and credit_amount>=99  and ifnull(g.amount,0)<99 and ar.credit_amount is not null  and session_total_price = 0 and year(session_time)=@yr and month(session_time)=@mo and ar.user_id not in (102545,24085,9173,44360,8909,46494,36097,107371,14078,60696,59833,70317,77175,22887,62059,56547,31090,34612,19311,58645,62110,121443,113731,12954,115846,116034,108276,83728, 47120)
group by ar.id
)a


left join credits cr on a.user_id=cr.user_id and a.credit_amount>=cr.amount

left join credit_types ct on cr.credit_type_id =ct.id
group by a.id) ar

group by credit_type


