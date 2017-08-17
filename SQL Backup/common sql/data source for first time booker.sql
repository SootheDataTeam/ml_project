select user_id,count(*) cnt from appointment_requests
where status ='completed'
group by user_id
having cnt=1

reviewed, discount,gift_amount,session_length,appointment_type, day from sign up to book, book hour ahead, city,referred or not 

select * from appointment_requests where user_id=141


select id,timestampdiff(day,u.created_at,a1.first) as signup_to_book,book_ahead,session_length,appointment_type,rating,a1.city,credit_amount,gift_amount,discount_amount,(case when cnt=1 then 'first' else 'repeat' end) as repeat_or_not
from users u 
join
(select user_id,count(*) cnt

from appointment_requests
where status='completed'
group by user_id)a on a.user_id=u.id
join
(select user_id,min(session_time) as first, timestampdiff(hour,ar.created_at,min(session_time)) as book_ahead,session_length,appointment_type,c.name as city,ifnull(credit_amount,0) as credit_amount,ifnull(gift_amount,0) as gift_amount,ifnull(discount_amount,0) as discount_amount

from appointment_requests ar
join cities c on c.id=ar.city_id
where status='completed'
group by user_id)a1 on a1.user_id=u.id
left join 
(select user_id, min(session_time) ,
case when r.value>4 then 'high rating'
when r.value<=4 then 'low rating'
else 'No Rating' end as rating	
from appointments a
left join (select appointment_id,value from reviews where recipient_id=therapist_id) r on r.appointment_id=a.id
where status in ('complete','reviewed') 

group by user_id
 )a2 on a2.user_id = u.id


where kind='client' and u.created_at<now()-interval 3 month and book_ahead>0


