select tx3.date,credit_type, sum(tx3.credit_amount) as credit_amount, sum(tx3.earnings)  as cost
from
(
select tx.*, tx2.earnings
from(
select credit_bookings.*, 
case 
when credit_amount >= 99 and gift_certificates_value >= 99 then 'gift_redemption'
when credit_amount >= 99 and session_total_price = 0 then 'free_massage'
when first_ar_id is not null and inviting_user_id is not null and credit_amount = 30 then 'client_referral'
when first_ar_id is not null and promo_code_value = credit_amount then 'first_time_code'
when first_ar_id is not null and promo_code_value is null then 'first_time_email'
when first_ar_id is null and credit_amount <= 20 then 'retention_small'
when first_ar_id is null and credit_amount <= 50 then 'retention_large'
else 'other' end as credit_type
from (
select ar.id, ar.credit_amount as credit_amount, session_total_price, year(ar.session_time) as yr,month(ar.session_time) as mo, DATE_FORMAT(ar.session_time,'%Y-%m') as date, ar.session_time as session_time, first_ar.id as first_ar_id, u.promo_code, u.invited_by_id as inviting_user_id, p.value as promo_code_value, g.amount as gift_certificates_value, ar.city_id 
from appointment_requests ar
left join (
select ar.id as id, ar.user_id as user_id, min(ar.created_at) as created_at
from appointment_requests ar
where ar.status='completed'
group by ar.user_id
) as first_ar
on ar.id = first_ar.id
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
where ar.status='completed' and (ar.credit_amount is not null and ar.credit_amount > 0) #and g.amount > 0
and ar.user_id not in (102545,24085,9173,44360,8909,46494,36097,107371,14078,60696,59833,70317,77175,22887,62059,56547,31090,34612,19311,58645,62110,121443,113731,12954,115846,116034,108276,83728, 47120)
) as credit_bookings
) as tx
left join (select ar.id as ar_id, a.id, sum(e.amount) as earnings
from appointment_requests ar
left join appointments a
on a.appointment_request_id = ar.id
left join earnings e
on e.appointment_id = a.id
where ar.status = 'completed'
group by ar.id) as tx2
on tx2.ar_id = tx.id

) tx3
group by tx3.date,  credit_type