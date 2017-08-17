#client_ranking
select a.user_id,round(sum(cnt)/weeks,2) as seven_Day_Frequency,
case when sum(cnt) >=5 and sum(cnt)/weeks>=2 then 'AAA'
when sum(cnt) >=4  and sum(cnt)/weeks>=1  then 'AA'
when sum(cnt) >=3 and sum(cnt)/weeks>=0.25  then 'A'
when sum(cnt) >=2   and sum(cnt)/weeks>=0.16   then 'B'
when sum(cnt) >=1  and sum(cnt)/weeks>=0   then 'C' end

as client_type
from
(select from_unixtime(unix_timestamp(ar.session_time) - unix_timestamp(ar.session_time) mod (7*24*60*60)) as ts1, ar.user_id, count(ar.id) as cnt
,case 
when e.wks >= (180/7) then (180/7)
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
and ar.session_time > (now()-interval 180 day)
group by ts1, ar.user_id
order by ts1, ar.user_id
 ) a
  
  group by a.user_id

