select days.each_date, aa.aa_count
from (
select a.Date as each_date
from (
    select curdate() - INTERVAL (a.a + (10 * b.a) + (100 * c.a)) DAY as Date
    from (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as a
    cross join (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as b
    cross join (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as c
) a
where a.Date between '2016-09-20' and '2016-11-20' 
) as days
left join (
	select count(*) as aa_count, date(aa.start_time) as date
	from advanced_appointments aa
	group by date(aa.start_time)
) as aa
on days.each_date = aa.date
order by days.each_date asc