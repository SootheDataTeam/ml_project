select a1.date,a1.client_type,round((a1.cnt-a2.cnt)/a2.cnt,2) as ratio
from
(select *
from
((select date_format(now(),'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(current_date(),min(DATE(ar.created_at))) tenure,
DATEDIFF(current_date(),max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(current_date(),min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(current_date(),min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1))
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type) 

union all
(select date_format(last_day(now())+interval 1 day -interval 2 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 1 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 1 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 1 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 1 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 1 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 3 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 2 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 2 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 2 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 2 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 2 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type) 
union all
(select date_format(last_day(now())+interval 1 day -interval 4 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 3 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 3 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 3 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 3 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 3 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type)
 
union all
(select date_format(last_day(now())+interval 1 day -interval 5 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 4 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 4 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 4 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 4 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 4 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type)
 
union all
(select date_format(last_day(now())+interval 1 day -interval 6 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 5 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 5 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 5 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 5 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 5 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type)) a

where client_type in ('A','AA','AAA')) a1 

join 
 (select *
from
((select date_format(now(),'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 1 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 1 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 1 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 1 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 1 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 2 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 2 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 2 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 2 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 2 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 2 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 3 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 3 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 3 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 3 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 3 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 3 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type)
 
union all
(select date_format(last_day(now())+interval 1 day -interval 4 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 4 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 4 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 4 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 4 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 4 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type)
 
union all
(select date_format(last_day(now())+interval 1 day -interval 5 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 5 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 5 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 5 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 5 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 5 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type)
 
union all
(select date_format(last_day(now())+interval 1 day -interval 6 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
else 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 6 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 6 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 6 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 6 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 6 month
group by user_id) a

join users u on u.id=a.user_id
)u1

group by client_type)) a

where client_type in ('A','AA','AAA')) a2 on a1.date=a2.date and a2.client_type=a1.client_type