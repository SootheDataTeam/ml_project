####market spending
##FB
select sum(cost)

from marketing_spendings
where channel='Facebook_Manual' and day>='2017-05-22' and day<'2017-05-29' and platform  not  in ('Instagram')

##Ins
select sum(cost)

from marketing_spendings
where channel='Facebook_Manual' and day>='2017-05-22' and day<'2017-05-29' and platform    in ('Instagram')

##google
select sum(cost)

from marketing_spendings
where channel='Google' and day>='2017-05-22' and day<'2017-05-29'


####
select sum(impressions)

from marketing_spendings
where channel='Facebook_Manual' and day>='2017-05-22' and day<'2017-05-29' and platform  not   in ('Instagram')

select sum(impressions)

from marketing_spendings
where channel='Google' and day>='2017-05-22' and day<'2017-05-29'

##### Repeat Bookers
select date_format(first,'%Y-%m') as yr_mo,  sum(case when u.cnt>1 then 1 else 0 end) as rep,count(*) ,sum(case when u.cnt>1 then 1 else 0 end)/count(*)
from
(select ar.user_id,first,count(*) as cnt
from
(select user_id,min(session_time) as first,city_id
 from appointment_requests
where status='completed'  
group by user_id) ar
join 
(select user_id,session_time  from appointment_requests where status='completed' ) u on u.user_id=ar.user_id
 
where  ar.first>=now()-interval 30 day 
group by user_id
) u



#####

select date_format(first,'%Y-%m') as yr_mo,  sum(case when u.cnt>1 then 1 else 0 end) as rep,count(*) ,sum(case when u.cnt>1 then 1 else 0 end)/count(*)
from
(select ar.user_id,first,count(*) as cnt
from
(select user_id,min(session_time) as first,city_id
 from appointment_requests
where status='completed'  
group by user_id) ar
join 
(select user_id,session_time  from appointment_requests where status='completed' ) u on u.user_id=ar.user_id
 
where  ar.first>=last_day(now()) +interval 1 day-interval 1 month 
group by user_id
) u


#####
select channel2,count(*)
from 

( SELECT
   
   CASE
   when source like '%instagram%' or '%Instagram%' then 'Instagram'
   WHEN campaign LIKE '%ROI%' then 'Facebook'
   
 
   
   when ( source like '%facebook%' or  source ='fb') then 'Facebook'
   
   WHEN source like '%google%' then 'Google'
   WHEN source like '%twitter%' then 'Twitter'
   
 
   WHEN source = 'Organic' then 'Organic'
 
   ELSE 'Other' END as channel2,
    u.id ,u.created_at
   from users u
   left join attributions a
   on u.attribution_id = a.id
   where u.kind='client' ) a
   
   
   where date(convert_tz(created_at,'UTC','US/Pacific'))>='2017-05-22' and date(convert_tz(created_at,'UTC','US/Pacific'))<'2017-05-29'
   group by channel2


####
select channel2,count(*)
from 

( SELECT
   
   CASE
   when source like '%instagram%' or '%Instagram%' then 'Instagram'
   WHEN campaign LIKE '%ROI%' then 'Facebook'
 
   
   when ( source like '%facebook%' or  source ='fb') then 'Facebook'
   
   WHEN source like '%google%' then 'Google'
   WHEN source like '%twitter%' then 'Twitter'
 
   WHEN source = 'Organic' then 'Organic'
 
   ELSE 'Other' END as channel2,
    u.id ,u.created_at
   from users u
   left join attributions a
   on u.attribution_id = a.id
   where u.kind='client' ) a
   
   join (select user_id,min(session_time) as first from appointment_requests where status ='completed' group by user_id) aa on aa.user_id=a.id
   
   where date(convert_tz(aa.first,'UTC','US/Pacific'))>='2017-05-22' and date(convert_tz(aa.first,'UTC','US/Pacific'))<'2017-05-29'
   group by channel2
   
   
####

select type,sum(cost)

from marketing_spendings m 

join marketing_spending_campaigns mc on mc.id=m.marketing_spending_campaign_id
where channel='Facebook_Manual' and platform    not   in ('Instagram') and type in ('UA','UART') and day>='2017-05-22' and day<'2017-05-29'  
group by type

####
select  sum(cost)

from marketing_spendings m 

join marketing_spending_campaigns mc on mc.id=m.marketing_spending_campaign_id
where channel='google'   and type in ('App Installs') and day>='2017-05-22' and day<'2017-05-29'  
 