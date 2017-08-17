
################Booking and Revenue data

Select ar.user_id, count(*) as booking_count, sum(ar.session_total_price), sum(ar.session_total_price+ifnull(gift_amount,0)+ifnull(ex.price,0)), year(ar.session_time), month(ar.session_time), 
(month(ar.session_time) + (year(ar.session_time) * 12) - (2013 * 12) - 7) as session_mo_offset, ua.first_active_at_mo, 
ua.first_active_at_yr, (year(ar.session_time) * 12 + month(ar.session_time)) - (ua.first_active_at_yr * 12 +  ua.first_active_at_mo)   as cohort_month, 
(ua.first_active_at_mo + (ua.first_active_at_yr * 12) - (2013 * 12) - 7) as activation_month, (billing_state = customer_state) as is_local,sum(ifnull(credit_amount,0)) as credit_amount
from appointment_requests ar
left join(select appointment_request_id, price from extensions) as ex
  on ex.appointment_request_id = ar.id
join (
select u.id, u.signup_type, count(*) as ar_count,
u.created_at, month(u.created_at) as created_at_mo, year(u.created_at) as created_at_yr, 
min(ar.session_time) as first_active_at, month(min(ar.session_time)) as first_active_at_mo, year(min(ar.session_time)) as first_active_at_yr
from users u
join appointment_requests ar
on ar.user_id = u.id
where u.kind = 'client' and (ar.status ='completed') 
group by u.id
) as ua
on ar.user_id = ua.id
where (ar.status ='completed') 
group by ar.user_id, year(ar.session_time), month(ar.session_time)



#############payout data
Select ar.user_id, count(*) as booking_count, sum(e.payout), year(ar.session_time), month(ar.session_time), 
(month(ar.session_time) + (year(ar.session_time) * 12) - (2013 * 12) - 7) as session_mo_offset, ua.first_active_at_mo, 
ua.first_active_at_yr, (year(ar.session_time) * 12 + month(ar.session_time)) - (ua.first_active_at_yr * 12 +  ua.first_active_at_mo)   as cohort_month, 
(ua.first_active_at_mo + (ua.first_active_at_yr * 12) - (2013 * 12) - 7) as activation_month,weekday,sign_up_day
from appointments ar
join (
select u.id, u.signup_type, count(*) as ar_count,
u.created_at, month(u.created_at) as created_at_mo, year(u.created_at) as created_at_yr, 
min(ar.session_time) as first_active_at, month(min(ar.session_time)) as first_active_at_mo, year(min(ar.session_time)) as first_active_at_yr,weekday(min(ar.session_time)) as weekday,date(u.created_at) as sign_up_day
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


 