select tx.*
from (
Select ar.user_id, count(*) as booking_count, sum(ar.session_total_price), sum(ar.session_total_price+ifnull(gift_amount,0)), year(ar.session_time), month(ar.session_time), 
(month(ar.session_time) + (year(ar.session_time) * 12) - (2013 * 12) - 7) as session_mo_offset, ua.first_active_at_mo, 
ua.first_active_at_yr, (year(ar.session_time) * 12 + month(ar.session_time)) - (ua.first_active_at_yr * 12 +  ua.first_active_at_mo)   as cohort_month, 
(ua.first_active_at_mo + (ua.first_active_at_yr * 12) - (2013 * 12) - 7) as activation_month, (billing_state = customer_state) as is_local
from appointment_requests ar
join (
select u.id, u.signup_type, count(*) as ar_count,
u.created_at, month(u.created_at) as created_at_mo, year(u.created_at) as created_at_yr, 
min(ar.created_at) as first_active_at, month(min(ar.created_at)) as first_active_at_mo, year(min(ar.created_at)) as first_active_at_yr
from users u
join appointment_requests ar
on ar.user_id = u.id
where u.kind = 'client' and (ar.status ='completed') 
group by u.id
) as ua
on ar.user_id = ua.id
where (ar.status ='completed') 
group by ar.user_id, year(ar.session_time), month(ar.session_time)
 
) as tx
