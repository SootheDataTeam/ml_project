select c.name as city,active_in_both_Month,new_hired,old_MT , cnt
from
(select a1.city_id,sum(case when a2.MT is not null then 1 else 0 end) as active_in_both_Month,
sum(case when a2.MT is null and date_format(u.created_at,'%Y-%m')=a1.date then 1 else 0 end) as new_hired,sum(case when a2.MT is null and date_format(u.created_at,'%Y-%m')!=a1.date then 1 else 0 end) as old_MT,count(*) as cnt
from
(select  therapist_id  as MT,year(ar.session_time) as yr,month(ar.session_time) as m,date_format(ar.session_time,'%Y-%m') as date,ar.city_id
	
from appointments a 
join appointment_requests ar on a.appointment_request_id=ar.id
where a.status in ('complete','reviewed') 
group by MT, yr,m,ar.city_id                                                                                                                                                                                                                                                                                                                                                
 ) a1

left join
(select therapist_id as MT,year(ar.session_time) as yr,month(ar.session_time) as m,ar.city_id,date_format(ar.session_time,'%Y-%m')  as date


from appointments a 
join appointment_requests ar on a.appointment_request_id=ar.id
where a.status in ('complete','reviewed')  
group by MT, yr,m,ar.city_id
 )a2 on a1.MT=a2.MT and  timestampdiff(month,concat(a2.date,'-01'),concat(a1.date,'-01'))=1  and a1.city_id=a2.city_id
 
join users u on u.id=a1.MT
where a1.city_id is not null
group by a1.city_id)a
join cities c on c.id=a.city_id
 
 
 ############
 

select a1.date,c.name as city,avg_appointments,bookings,active_MT,fill_rate

from
(select date_format(a.session_time,'%Y-%m') as date,count(*)/count(distinct(therapist_id)) as avg_appointments ,count(distinct(therapist_id)) as active_MT ,count(*) as bookings,ar.city_id

from appointments a 
join appointment_requests ar on a.appointment_request_id=ar.id
where a.status in ('complete','reviewed')  

group by date,ar.city_id) a1
 join
(select date_format(session_time,'%Y-%m') as date, count(*) as completed,sum(case when ar.status='completed' then 1 else 0 end)/count(*)as fill_rate,ar.city_id

from appointment_requests ar
where (ar.status='completed' or (ar.status='cancelled' and is_unfilled=True))  
group by date,ar.city_id)a2 on a1.date=a2.date and a1.city_id=a2.city_id
join cities c on c.id=a1.city_id