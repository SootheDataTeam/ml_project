set @group='', @row = 0;


select sixtymin_session ,nintymin_session,twohour_session,special_requests,case when Instagram>0 then 1 else 0 end as Instagram,case when facebook>0 then 1 else 0 end as facebook,
case when google>0 then 1 else 0 end as google, case when Twitter>0 then 1 else 0 end as Twitter,case when email>0 then 1 else 0 end as email,case when Bing>0 then 1 else 0 end as Bing,
case when Yelp>0 then 1 else 0 end as Yelp, signupgap as interval_most_recent2,


case 
    when completed_sessions=1 then 'First Timer'
    when completed_sessions>=2 and completed_sessions<=5 then 'Repeat Customer'
    when  completed_sessions>=6 and completed_sessions<=10 then 'Valued Customer'
    else 'Highly Valued Customer' end as type 
from
(select tx2.user_id,tx2.ar_session_time,  sum(case when session_length=60 then 1 else 0 end)  as sixtymin_session ,sum(case when session_length=90 then 1 else 0 end) as nintymin_session ,sum(case when session_length=120 then 1 else 0 end) as twohour_session
,sum(case when id in (select appointment_request_id  from therapist_preferences) then 1 else 0 end)as special_requests,sum(case when credit_amount>0 then 1 else 0 end) as credit,sum(case when gift_amount>0 then 1 else 0 end) as gift
from 
(select tx.*, @row:=if(@group=tx.user_id,@row+1,1) as rank, @group:=tx.user_id
from (
select ar.id, ar.user_id, date(ar.session_time) as ar_session_time, ar.status,session_time,session_length,credit_amount,gift_amount

from appointment_requests ar


where 
(ar.status = 'completed')  
order by user_id,ar_session_time desc

) as tx ) as tx2


where tx2.rank<=2
group by tx2.user_id) a 

join (select user_id,count(*)as completed_sessions  from appointment_requests
where status='completed'
group by user_id
having completed_sessions>1) sl on sl.user_id=a.user_id
 

join
(select user_id,sum(case when source like'%instagram%' then 1 else 0 end) as Instagram, sum(case WHEN (campaign LIKE '%ROI%') or ( source like '%facebook%' or  source ='fb') then 1 else 0 end) as facebook,sum(case when source like '%google%' then 1 else 0 end) as google,
sum(case WHEN source like '%twitter%' then 1 else 0 end) as Twitter,sum(case when source like '%mail%' then 1 else 0 end) as email,sum(case WHEN source = 'bing' then 1 else 0 end) as Bing,sum(case WHEN source like '%yelp%' then 1 else 0 end) as Yelp

from attributions 

group by user_id
 ) att on att.user_id=a.user_id 
join (select ar.user_id,timestampdiff(day,max(a.session_time),max(ar.session_time)) as signupgap

from appointment_requests ar
join (select user_id, session_time
from appointment_requests
where status='completed'
)a on a.user_id=ar.user_id
where a.session_time<ar.session_time

group by ar.user_id ) si on si.user_id=a.user_id
