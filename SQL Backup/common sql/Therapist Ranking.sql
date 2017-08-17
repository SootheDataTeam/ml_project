#therapist_ranking
select u.id,ifnull(group_ABC,'D') as group_ABCD

from
users u
left join
(select a.therapist_id, count(*) as total,
case when count(*)>=250 then 'A' 
when (count(*)>=80 and count(*)<250) then 'B' 
when count(*)<80 then 'C'  end as group_ABC

from appointments a 

where a.session_time>=last_day(now())+ interval 1 day-interval 12 month and (a.status='complete' or a.status='reviewed') 
group by a.therapist_id) a on a.therapist_id=u.id

where u.kind='therapist'
order by  total desc
