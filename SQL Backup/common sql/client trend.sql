select date,client_type,sum(cnt) as num
from
(select date ,case when client_type in ('AAA','AA') then 'AA or above' else client_type end as client_type ,cnt
from
((select date_format(now(),'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
 
when num_completed_requests>=1 then 'C'end as client_type
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
where client_type <> ''
group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 2 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
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
where client_type <> ''
group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 3 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
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
where client_type <> ''
group by client_type)
union all
(select date_format(last_day(now())+interval 1 day -interval 4 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
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
where client_type <> ''
group by client_type)
 
union all
(select date_format(last_day(now())+interval 1 day -interval 5 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
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
where client_type <> ''
group by client_type)
 
union all
(select date_format(last_day(now())+interval 1 day -interval 6 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
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
where client_type <> ''
group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 7 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
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
where client_type <> ''
group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 8 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 7 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 7 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 7 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 7 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 7 month
group by user_id) a

join users u on u.id=a.user_id
)u1
where client_type <> ''
group by client_type)
union all
(select date_format(last_day(now())+interval 1 day -interval 9 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 8 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 8 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 8 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 8 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 8 month
group by user_id) a

join users u on u.id=a.user_id
)u1
where client_type <> ''
group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 10 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 9 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 9 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 9 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 9 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 9 month
group by user_id) a

join users u on u.id=a.user_id
)u1
where client_type <> ''
group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 11 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 10 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 10 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 10 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 10 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 10 month
group by user_id) a

join users u on u.id=a.user_id
)u1
where client_type <> ''
group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 12 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 11 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 11 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 11 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 11 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 11 month
group by user_id) a

join users u on u.id=a.user_id
)u1
where client_type <> ''
group by client_type)

union all
(select date_format(last_day(now())+interval 1 day -interval 13 month,'%Y-%m') as date,client_type,count(*) as cnt
from
(select a.user_id, concat(u.first_name," ", u.last_name) as name, num_completed_requests,weekly_freq, 
case when num_completed_requests>=6 and weekly_freq<=0 then 'AAA'
when num_completed_requests>=5 and weekly_freq<=2 then 'AA'
when num_completed_requests>=3 and weekly_freq<=4 then 'A'
when num_completed_requests>=2 and weekly_freq<=12 then 'B'
when num_completed_requests>=1 then 'C' end as client_type
from
(SELECT
user_id,
DATEDIFF(last_day(now()) -interval 12 month,min(DATE(ar.created_at))) tenure,
DATEDIFF(last_day(now()) -interval 12 month,max(DATE(ar.created_at))) recency,
count(*) num_requests,
sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
sum(is_unfilled) unfilled_apts,
DATEDIFF(last_day(now()) -interval 12 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq,
truncate((DATEDIFF(last_day(now()) -interval 12 month,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_freq

FROM
appointment_requests ar
WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and session_time<last_day(now())+interval 1 day -interval 12 month
group by user_id) a

join users u on u.id=a.user_id
)u1
where client_type <> ''
group by client_type)


) a

)a
 group by date,client_type