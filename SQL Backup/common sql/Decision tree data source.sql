
select case when sixtymin_session>0 then 1 else 0 end as sixtymin_session ,case when nintymin_session>0 then 1 else 0 end as nintymin_session,case when twohour_session>0 then 1 else 0 end as twohour_session,
case when special_requests>0 then 1 else 0 end as special_requests,case when credit>0 then 1 else 0 end as credit, case when gift>0 then 1 else 0 end as gift,case when Instagram>0 then 1 else 0 end as Instagram,case when facebook>0 then 1 else 0 end as facebook,
case when google>0 then 1 else 0 end as google, case when Twitter>0 then 1 else 0 end as Twitter,case when email>0 then 1 else 0 end as email,case when Bing>0 then 1 else 0 end as Bing,
case when Yelp>0 then 1 else 0 end as Yelp,gap as interval_firsttwobookings,signupgap as interval_firstbookingandsignup,


case 
    when completed_sessions=1 then 'First Timer'
    when completed_sessions>=2 and completed_sessions<=5 then 'Repeat Customer'
    when  completed_sessions>=6 and completed_sessions<=10 then 'Valued Customer'
    else 'Highly Valued Customer' end as type


from
(select user_id,sum(case when session_length=60 then 1 else 0 end)  as sixtymin_session ,sum(case when session_length=90 then 1 else 0 end) as nintymin_session ,sum(case when session_length=120 then 1 else 0 end) as twohour_session
,sum(case when id in (select appointment_request_id  from therapist_preferences) then 1 else 0 end)as special_requests,sum(case when credit_amount>0 then 1 else 0 end) as credit,count(*) as completed_sessions,sum(case when gift_amount>0 then 1 else 0 end) as gift


from appointment_requests
where status='completed'
group by user_id
having completed_sessions>1) sl
join
(select user_id,sum(case when source like'%instagram%' then 1 else 0 end) as Instagram, sum(case WHEN (campaign LIKE '%ROI%') or ( source like '%facebook%' or  source ='fb') then 1 else 0 end) as facebook,sum(case when source like '%google%' then 1 else 0 end) as google,
sum(case WHEN source like '%twitter%' then 1 else 0 end) as Twitter,sum(case when source like '%mail%' then 1 else 0 end) as email,sum(case WHEN source = 'bing' then 1 else 0 end) as Bing,sum(case WHEN source like '%yelp%' then 1 else 0 end) as Yelp

from attributions 

group by user_id
 ) att on att.user_id=sl.user_id 
join 
(select ar.user_id,timestampdiff(day,u.first,min(session_time)) as gap  

from appointment_requests ar
join
(select user_id,min(session_time) as first,city_id
 from appointment_requests
where status='completed' 
group by user_id) u on u.user_id=ar.user_id
where status='completed' and u.first<ar.session_time

group by user_id) b on b.user_id=sl.user_id

join (select user_id,timestampdiff(day,u.created_at,min(session_time)) as signupgap

from appointment_requests ar

join

(select id, created_at from users where kind='client')u on u.id=ar.user_id
where ar.status='completed' and session_time>u.created_at
group by user_id ) si on si.user_id=sl.user_id

 
 


