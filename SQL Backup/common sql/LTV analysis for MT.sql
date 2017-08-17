

select u.id,date_format(u.created_at,'%Y-%m') as create_date,timestampdiff(month,u.created_at,session_time) as cohort_month,sum(case when timestampdiff(month,u.created_at,session_time) is null then 0 else 1 end) as bookings,sum(total_spend) as revenue,city

from
(select id,created_at,city


from users u 

where u.kind='therapist' and suspended <>1) u


left join (select therapist_id,ar.session_time,ifnull(ar.session_total_price+ifnull(ar.gift_amount,0),0) as total_spend
from appointments a
join appointment_requests ar on ar.id=a.appointment_request_id
where a.status in ('complete','reviewed')) a on a.therapist_id=u.id

group by u.id,cohort_month

order by u.id,create_date

####group by ABC

 select f.therapist_id as ID,u.first_name,u.last_name,u.mobile_number as mobile,u.email,
case when total>=250 then 'A : Sessions>=250' 
when (total>=80 and total<250) then 'B : Sessions>=80' 
else  'C : Sessions<80'  end as group_ABC  

from
  (select id,u.first_name,u.last_name,u.mobile_number,u.email from users u where kind='therapist' ) u
left join
(select a.therapist_id, count(*) as total

from appointments a 

where   therapist_id not in (19835,6918,102,263) and  a.session_time>=last_day(now()-interval 1 month)+ interval 1 day-interval 12 month and a.session_time <last_day(now()-interval 1 month)+ interval 1 day and (a.status='complete' or a.status='reviewed') 
group by therapist_id) f on u.id=f.therapist_id
 
 
order by group_ABC