select sum(amount)
from earnings
where status='paid' and transfer_id is not null





select *
from
(select 
e.id, e.amount,e.created_at,ar.session_time,
e.description as description_original
,ifnull(ar.city_id,0) as city_id
from
 earnings e
left join appointments a on a.id=e.appointment_id
left join appointment_requests ar on ar.id=a.appointment_request_id
where e.status='paid' and date_format(e.created_at,'%Y-%m') >='2015-12') ar

 
######payout with appointment with app id


set @x1 = '2013-6-30 00:00',@x2 = '2016-12-30 00:00';
select e.therapist_id,a.id,date(convert_tz(session_time,'UTC',case ap.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else ap.timezone end)) as date,a.session_time,date(sent_at) as strip_date, ap.city,e.amount,e.description,a.status

from appointments a
 join
(select ar.id,n.name as city,ar.timezone

from
appointment_requests ar
left join (		
	select c.id, c.name
    from cities c
) as n		
on n.id = ar.city_id
where  ar.status in ('completed','cancelled') and ar.session_time>=@x1 and ar.session_time<=@x2 and ar.city_id  in (select id from cities where country  in ('US'))) ap on ap.id=a.appointment_request_id
join earnings e on  e.appointment_id = a.id 
where e.status='paid' and e.transfer_id is not null 

####oversea
set @x1 = '2013-6-30 00:00',@x2 = '2016-12-30 00:00';
select e.therapist_id,a.id,date(convert_tz(a.session_time,'UTC',case ap.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else ap.timezone end)) as date,a.session_time,date(sent_at) as strip_date,ap.city,e.amount,e.description,a.status

from appointments a
 join
(select ar.id,n.name as city,timezone

from
appointment_requests ar
left join (		
	select c.id, c.name
    from cities c
) as n		
on n.id = ar.city_id
where  ar.status in ('completed','cancelled') and ar.session_time>=@x1 and ar.session_time<=@x2 and ar.city_id  not in (select id from cities where country in ('US'))) ap on ap.id=a.appointment_request_id
join earnings e on  e.appointment_id = a.id 
where e.status='paid'




######payout with appointment without app id


select *,date(created_at) as mo,date(sent_at) as strip_date from earnings where appointment_id is null and status='paid' and transfer_id is not null 






####

select t.transfer_stripe_id, DATE_FORMAT(t.created_at,'%Y-%m') as transfer_date,t.amount as transfer_amount,  e.id as earning_id,e.amount, DATE_FORMAT(e.created_at,'%Y-%m') as earning_date, e.description, a.id as appointment_id,DATE_FORMAT(a.session_time,'%Y-%m') as session_date, r.status,r.city_id
from transfers t
left join earnings e
on e.transfer_id = t.id
left join appointments a
on e.appointment_id = a.id
left join appointment_requests r
on r.id = a.appointment_request_id
where year(r.session_time) = '2016' and month(r.session_time)=1 # and (monthname(t.created_at) = 'august' or monthname(t.created_at) = 'july')




select sum(transfer_amount)
from
(select t.transfer_stripe_id, DATE_FORMAT(t.created_at,'%Y-%m') as transfer_date,t.amount/100 as transfer_amount,  e.id as earning_id,e.amount, DATE_FORMAT(e.created_at,'%Y-%m') as earning_date, e.description, a.id as appointment_id,DATE_FORMAT(a.session_time,'%Y-%m') as session_date
from transfers t
join earnings e
on e.transfer_id = t.id
 join appointments a
on e.appointment_id = a.id

where year(a.session_time) = '2016' and month(a.session_time)=8 and e.status='paid' 
group by t.id
)a



####


select * from earnings where appointment_id=62173



select sum(amount)/100 from transfers where id=37421


select sum(amount)/100 from transfers where id not in (select transfer_id from earnings where transfer_id is not null) and date(created_at)>='2016-01-01'



select date_format(created_at,"%Y-%m") as date,sum(amount)/100 from transfers where date(created_at)>='2016-01-01' and date(created_at)<='2016-07-31'


###3
select * from marketing_spendings_nanigans











group by date