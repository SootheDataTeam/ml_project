#@x1 = beginning #@x2 = end

set @x1 = last_day(now())+interval 1 day-interval 1 month, @x2 = last_day(now());

(select cu.name as city,cu.revenue,cu.revenue/lt.revenue-1 as revenue_growth,cu.cnt as bookings, cu.cnt/lt.cnt-1 as bookings_growth,cu.first_bookers as first_time,cu.first_bookers/lt.first_bookers -1 as first_time_growth,cu.rp as repeat_booking,cu.rp/lt.rp-1 as repeat_growth
from
(select f.year_mo,f.name,(ifnull(s.spending,0)+s2.spending/f3.cnt*f2.cnt)/f.cnt as mixed_CAC, ifnull(s.spending,0)/f.cnt as unmixed_CAC,f2.fill_rate,ifnull(s.spending,0) as city_spending,s2.spending/f3.cnt*f2.cnt as allocated_spending,f.cnt as first_bookers,f2.revenue,(f2.cnt-f.cnt) as rp,f2.cnt as cnt
from
(select DATE_FORMAT(session_time,'%Y-%m') as year_mo,sum(case when status='completed' or status ='filled' then session_total_price + ifnull(gift_amount,0) else 0 end) as revenue,sum(case when status='completed' or status ='filled' then 1 else 0 end) as cnt,sum(case when status='completed' or status ='filled' then 1 else 0 end)/count(*) as fill_rate,c.name  from appointment_requests ar join cities c on c.id=ar.city_id where (ar.status='completed' or ar.status='cancelled' and ar.is_unfilled=1) and ar.session_time>=@x1 and ar.session_time<=@x2 group by c.name ) f2


left join
(select  year_mo, name, count(distinct(user_id)) as cnt

from(
(select session_length, ar.user_id, case ar.session_time when j.tm then 'FT' else 'Repeat' end as first,



DATE_FORMAT(session_time,'%Y-%m') as year_mo,  n.name,

	
ar.status		
from appointment_requests ar		
left join (		
	select c.id, c.name
    from cities c
) as n		
on n.id = ar.city_id	

left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id

where (ar.status ='completed' or ar.status='filled' )
and ar.session_time >= @x1 and ar.session_time <= @x2
group by ar.id
order by session_time asc)
) as tx

where first = 'ft'
group by  year_mo, name) f on f2.year_mo=f2.year_mo and f.name=f2.name
left join
(select date_format(day,'%Y-%m') as date,ifnull(c.name,0) as name ,sum(cost) as spending
from marketing_spendings m
join cities c on c.id=m.city_id
where day>=date(@x1)
group by date,c.name) s on f2.year_mo=s.date and f2.name=s.name
 

, (select date_format(day,'%Y-%m') as date,sum(cost) as spending
from marketing_spendings m
where city_id=0 and day>=date(@x1)
group by date) s2  ,(select count(*) as cnt from appointment_requests ar  where ar.status='completed' and ar.session_time>=@x1 and ar.session_time<=@x2  ) f3) cu


join

(select f.year_mo,f.name,(ifnull(s.spending,0)+s2.spending/f3.cnt*f2.cnt)/f.cnt as mixed_CAC, ifnull(s.spending,0)/f.cnt as unmixed_cac,f2.fill_rate,ifnull(s.spending,0) as city_spending,s2.spending/f3.cnt*f2.cnt as allocated_spending,f.cnt as first_bookers,f2.revenue,(f2.cnt-f.cnt) as rp,f2.cnt as cnt
from
(select DATE_FORMAT(session_time,'%Y-%m') as year_mo,sum(case when status='completed' or status ='filled' then session_total_price + ifnull(gift_amount,0) else 0 end) as revenue,sum(case when status='completed' or status ='filled' then 1 else 0 end) as cnt,sum(case when status='completed' or status ='filled' then 1 else 0 end)/count(*) as fill_rate,c.name  
from appointment_requests ar join cities c on c.id=ar.city_id 
where (ar.status='completed' or ar.status='cancelled' and ar.is_unfilled=1) and ar.session_time>=last_day(now())+interval 1 day-interval 2 month and ar.session_time<=last_day(now())+interval 1 day-interval 2 month +interval day(now())-1 day group by c.name ) f2


left join
(select  year_mo, name, count(distinct(user_id)) as cnt

from(
(select session_length, ar.user_id, case ar.session_time when j.tm then 'FT' else 'Repeat' end as first,



DATE_FORMAT(session_time,'%Y-%m') as year_mo,  n.name,

	
ar.status		
from appointment_requests ar		
left join (		
	select c.id, c.name
    from cities c
) as n		
on n.id = ar.city_id	

left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id

where (ar.status ='completed' or ar.status='filled' )
and ar.session_time >= last_day(now())+interval 1 day-interval 2 month and ar.session_time <= last_day(now())+interval 1 day-interval 2 month +interval day(now())-1 day
group by ar.id
order by session_time asc)
) as tx

where first = 'ft'
group by  year_mo, name) f on f2.year_mo=f2.year_mo and f.name=f2.name
left join
(select date_format(day,'%Y-%m') as date,ifnull(c.name,0) as name ,sum(cost) as spending
from marketing_spendings m
join cities c on c.id=m.city_id
where day>=date(last_day(now())+interval 1 day-interval 2 month) and day<=date(last_day(now())+interval 1 day-interval 2 month +interval day(now())-1 day )
group by date,c.name) s on f2.year_mo=s.date and f2.name=s.name
 

, (select date_format(day,'%Y-%m') as date,sum(cost) as spending
from marketing_spendings m
where city_id=0 and day>=date(last_day(now())+interval 1 day-interval 2 month) and day<=date(last_day(now())+interval 1 day-interval 2 month +interval day(now())-1 day )
group by date) s2  ,(select count(*) as cnt from appointment_requests ar  where ar.status='completed' and ar.session_time>=last_day(now())+interval 1 day-interval 2 month and ar.session_time<=last_day(now())+interval 1 day-interval 2 month +interval day(now())-1 day  ) f3) lt on cu.name=lt.name
order by city)


union all
(select 'Overall',cu.revenue,cu.revenue/lt.revenue-1 as revenue_growth,cu.cnt as bookings, cu.cnt/lt.cnt-1 as bookings_growth,cu.first_bookers as first_time,cu.first_bookers/lt.first_bookers -1 as first_time_growth,cu.rp as repeat_booking,cu.rp/lt.rp-1 as repeat_growth
from
(select f.year_mo, session_time,(s2.spending)/f.cnt as mixed_CAC, ifnull(s2.spending,0)/f.cnt as unmixed_cac, f2.fill_rate,f.cnt as first_bookers,f2.revenue,(f2.cnt-f.cnt) as rp,f2.cnt as cnt
from
(select DATE_FORMAT(session_time,'%Y-%m') as year_mo,sum(case when status='completed' or status ='filled' then session_total_price + ifnull(gift_amount,0) else 0 end) as revenue,sum(case when status='completed' or status ='filled' then 1 else 0 end) as cnt,sum(case when status='completed' or status ='filled' then 1 else 0 end)/count(*) as fill_rate from appointment_requests ar where (ar.status='completed' or ar.status='cancelled' and ar.is_unfilled=1) and ar.session_time>=@x1 and ar.session_time<=@x2  ) f2


left join
(select  year_mo,  count(distinct(user_id)) as cnt,session_time

from(

(select session_length, ar.user_id, case ar.session_time when j.tm then 'FT' else 'Repeat' end as first,



DATE_FORMAT(session_time,'%Y-%m') as year_mo, session_time,

	
ar.status		
from appointment_requests ar		
left join (		
	select c.id, c.name
    from cities c
) as n		
on n.id = ar.city_id	

left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id

where (ar.status ='completed' or ar.status='filled' )
and ar.session_time >= @x1 and ar.session_time <= @x2
group by ar.id
order by session_time asc)
) as tx

where first = 'ft'
group by  year_mo) f on f2.year_mo=f2.year_mo

 

, (select date_format(day,'%Y-%m') as date,sum(cost) as spending
from marketing_spendings m
where  day>=date(@x1)
group by date) s2  ) cu


join

(select f.year_mo, session_time,(s2.spending)/f.cnt as mixed_CAC, ifnull(s2.spending,0)/f.cnt as unmixed_cac,f2.fill_rate,f.cnt as first_bookers,f2.revenue,(f2.cnt-f.cnt) as rp,f2.cnt as cnt
from
(select DATE_FORMAT(session_time,'%Y-%m') as year_mo,sum(case when status='completed' or status ='filled' then session_total_price + ifnull(gift_amount,0) else 0 end) as revenue,sum(case when status='completed' or status ='filled' then 1 else 0 end) as cnt,sum(case when status='completed' or status ='filled' then 1 else 0 end)/count(*) as fill_rate 
from appointment_requests ar 
where (ar.status='completed' or ar.status='cancelled' and ar.is_unfilled=1) and ar.session_time>=last_day(now())+interval 1 day-interval 2 month and ar.session_time<=last_day(now())+interval 1 day-interval 2 month +interval day(now())-1 day  ) f2


left join
(select  year_mo,  count(distinct(user_id)) as cnt,session_time

from(
(select session_length, ar.user_id, case ar.session_time when j.tm then 'FT' else 'Repeat' end as first,



DATE_FORMAT(session_time,'%Y-%m') as year_mo, session_time ,

	
ar.status		
from appointment_requests ar		
left join (		
	select c.id, c.name
    from cities c
) as n		
on n.id = ar.city_id	

left join(select user_id, min(session_time) as tm from appointment_requests p where status ='completed' or status = 'filled' or status = 'pending' group by user_id) as j on j.user_id = ar.user_id

where (ar.status ='completed' or ar.status='filled' )
and ar.session_time >= last_day(now())+interval 1 day-interval 2 month and ar.session_time <= last_day(now())+interval 1 day-interval 2 month +interval day(now())-1 day
group by ar.id
order by session_time asc)
) as tx

where first = 'ft'
group by  year_mo) f on f2.year_mo=f2.year_mo 

 

, (select date_format(day,'%Y-%m') as date,sum(cost) as spending
from marketing_spendings m
where  day>=date(last_day(now())+interval 1 day-interval 2 month) and day<=date(last_day(now())+interval 1 day-interval 2 month +interval day(now())-1 day )
group by date) s2  )lt on date_format(date(lt.session_time)+interval 1 month,'%Y-%m')=date_format(cu.session_time,'%Y-%m')  )




