 ###First Time User by source [last 6 Month]
 
 select source,count(*)
 from
(select case when f1.source like 'yelp%' then 'Yelp'
when (f1.source like '%facebook%' or f1.source ='fb') then 'Facebook'
 
when f1.source like '%google%' then 'Google'
when f1.source like '%twitter%' then 'Twitter'
when f1.source like '%instagram%' then 'Instagram'
when f1.source like '%mail%' then 'Email'
when f1.source  ='Organic' then 'Organic'
when f1.source  ='bing' then 'Bing'
else   'other' end as source 
from

(select user_id,min(session_time) as first from appointment_requests ar  where status='completed' group by user_id) ar 
left join 
(select  user_id, min( created_at), source from attributions att where source is not null group by  user_id) f1 on f1.user_id=ar.user_id

where ar.first>=last_day(now())+interval 1 day-interval 7 month and  ar.first<last_day(now())+interval 1 day-interval 1 month  ) a

 group by source
 
## Profit by Source [last 6 Month]

select source, round(sum(margin),1) as revenue
from
(
select case when f1.source like 'yelp%' then 'Yelp'
when (f1.source like '%facebook%' or f1.source ='fb') then 'Facebook'
 
when f1.source like '%google%' then 'Google'
when f1.source like '%twitter%' then 'Twitter'
when f1.source like '%instagram%' then 'Instagram'
when f1.source like '%mail%' then 'Email'
when f1.source  ='Organic' then 'Organic'
when f1.source  ='bing' then 'Bing'
else   'other' end as source ,(total_spend-payout) as margin
from appointment_requests ar
 left join (select  user_id, min( created_at), source from attributions att where source is not null group by  user_id) f1 on f1.user_id=ar.user_id
 join (select appointment_request_id,sum(e.amount) as payout from appointments a 
 join earnings e on e.appointment_id=a.id 
 
 group by appointment_request_id) a on a.appointment_request_id=ar.id
  where session_time>=last_day(now())+interval 1 day-interval 7 month and  session_time<last_day(now())+interval 1 day-interval 1 month and ar.status='completed'
  ) f
 group by source 
 
 
 
 select  last_day(now())+interval 1 day-interval 1 month