

select zip_code,n.name, latitude,longitude,request
from neighborhoods n
left join (select customer_zip,ar.city_id,count(*) as request from appointment_requests ar
where (ar.status ='completed' or ar.status='cancelled' and ar.id in (select id
from appointment_requests ar
where cancelled_by_id is not null
and cancelled_by_id != user_id
and (TIMESTAMPDIFF(SECOND, updated_at, ar.session_time) / 60) <= 60
order by (TIMESTAMPDIFF(SECOND, updated_at, session_time)) asc) ) 
group by customer_zip
) ar on ar.customer_zip=n.zip_code and ar.city_id=n.city_id
where n.city_id=2
order by request desc