#client_ranking

select u.id, ifnull(seven_Day_Frequency,0) as seven_Day_Frequency, ifnull(client_type,'D') as client_type
from
users u 
left join (select a.user_id,round(sum(cnt)/weeks,2) as seven_Day_Frequency,
case when sum(cnt) >=5 and sum(cnt)/weeks>=2 then 'AAA'
when sum(cnt) >=4  and sum(cnt)/weeks>=1  then 'AA'
when sum(cnt) >=3 and sum(cnt)/weeks>=0.25  then 'A'
when sum(cnt) >=2   and sum(cnt)/weeks>=0.16   then 'B'
when sum(cnt) >=1  and sum(cnt)/weeks>=0   then 'C' end

as client_type
from
(select from_unixtime(unix_timestamp(ar.session_time) - unix_timestamp(ar.session_time) mod (7*24*60*60)) as ts1, ar.user_id, count(ar.id) as cnt
,case 
when e.wks >= (90/7) then (90/7)
when e.wks < (1) then 1
else e.wks
end as weeks

from appointment_requests ar

left join(select user_id, (unix_timestamp(now()) - unix_timestamp(min(session_time)))/(7*24*60*60) as wks
from appointment_requests
where status = 'completed'
group by user_id) as e
 on e.user_id = ar.user_id

where ar.status = 'completed'
and ar.session_time > (now()-interval 90 day)
group by ts1, ar.user_id
order by ts1, ar.user_id
 ) a
  
  group by a.user_id)a on u.id=a.user_id

where u.kind='client'
order by seven_Day_Frequency desc

