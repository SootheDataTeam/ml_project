

set @x1='2016-05';

select 
case when e.appointment_id is not null then 'B2C'
else case when e.description like '%B2B%Soothe At Work%' then 'B2B' 
 when  e.description like '%street%event%' then 'Street/Event' 
 when  e.description like '%bonus' then 'Therapist Bonuses'
else  'Other Therapist Payments'
end 
end

from transfers t
join
earnings e on e.transfer_id=t.id
where e.status='paid' and date_format(t.created_at,'%Y-%m')=@x1

 

transfer_strip_id
select * from transfers where id=89948
select * from earnings



#### transfer id is not null

set @x1='2016-07';

select 
t.id,t.transfer_stripe_id,e.amount,t.created_at,
case when e.appointment_id is not null then 'B2C'
else case when e.description like '%Soothe At Work%' then 'B2B' 
 when  e.description like '%event%' then 'Street/Event' 
 when  e.description like '%bonus' then 'Therapist Bonuses'
else  'Other Therapist Payments'
end 
end as description

from transfers t
join
earnings e on e.transfer_id=t.id
where e.status='paid' and date_format(t.created_at,'%Y-%m')=@x1 


####modified not in oversea country

set @x1='2016-07';
select *
from
(select 
t.id,t.transfer_stripe_id,e.amount,t.created_at,
case when e.appointment_id is not null then 'B2C'
else case when e.description like '%Soothe At Work%' then 'B2B' 
 when  e.description like '%event%' then 'Street/Event' 
 when  e.description like '%bonus%' then 'Therapist Bonuses'
else  'Other Therapist Payments'
end 
end as description,e.description as description_original
,ifnull(ar.city_id,0) as city_id

from transfers t
join
earnings e on e.transfer_id=t.id
left join appointments a on a.id=e.appointment_id
left join appointment_requests ar on ar.id=a.appointment_request_id
where e.status='paid' and date_format(t.created_at,'%Y-%m')=@x1) ar

where city_id  not in (select id from cities where country not in ('US'))







#####test


set @x1='2016-07';
select sum(amount)
from
(select 
e.amount,ifnull(ar.city_id,0) as city_id

from transfers t
join
earnings e on e.transfer_id=t.id
left join appointments a on a.id=e.appointment_id
left join appointment_requests ar on ar.id=a.appointment_request_id
where e.status='paid' and date_format(t.created_at,'%Y-%m')=@x1) ar

where city_id  not in (select id from cities where country not in ('US'))




select 
sum(e.amount)

from transfers t
join
earnings e on e.transfer_id=t.id
 
where e.status='paid' and date_format(t.created_at,'%Y-%m')=@x1  




#### transfer id is null
set @x1='2016-07';

select e.id,amount,e.created_at,e.transfer_id,ar.city_id

from earnings e
join appointments a on a.id=e.appointment_id
join appointment_requests ar on ar.id=a.appointment_request_id

where e.status='paid' and ar.city_id in (select id from cities where country <> 'US') and date_format(e.created_at,'%Y-%m')=@x1 




set @x1='2016-07';

select sum(e.amount)

from earnings e
join appointments a on a.id=e.appointment_id
join appointment_requests ar on ar.id=a.appointment_request_id

where e.status='paid' and ar.city_id in (select id from cities where country <> 'US') and date_format(e.created_at,'%Y-%m')=@x1 and transfer_id is not null




######








select * from transfers


set @x1='2016-07';
select sum(amount) from transfers where date_format(created_at,'%Y-%m')=@x1 






