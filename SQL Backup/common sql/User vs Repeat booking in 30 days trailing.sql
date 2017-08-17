select a.Date , (select count(distinct(user_id)) as cnt from appointment_requests where status='completed' and timestampdiff(day,date(session_time),a.Date) between 0 and 29 ) as active_users,(select count(*) as cnt from appointment_requests where status='completed' and timestampdiff(day,date(session_time),a.Date) between 0 and 29 and is_repeat=1 ) as repeat_bookings
from (
    select curdate() - INTERVAL (a.a + (10 * b.a) + (100 * c.a)) DAY as Date
    from (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as a
    cross join (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as b
    cross join (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as c

order by Date) a
where a.Date >=date(now()-interval 30 day)
