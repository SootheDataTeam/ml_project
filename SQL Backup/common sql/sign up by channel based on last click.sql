 ###sign up by channel
 
 select date_format(created_at,'%Y-%m') as date ,channel2 as channel,count(*) new_signups,
 sum(case when id in (select user_id from (select user_id,count(*) as cnt from appointments where status in ('complete','reviewed') group by user_id having cnt=1)a) then 1 else 0 end) as first_time_booker,
  sum(case when id in (select user_id from (select user_id,count(*) as cnt from appointments where status in ('complete','reviewed') group by user_id having cnt>1)a) then 1 else 0 end) as repeat_booker
 
 from 
 ( SELECT 
     
    CASE 
    when source like '%instagram%' or '%Instagram%' then 'Instagram'
    WHEN campaign LIKE '%ROI%' then 'Facebook'
     
    WHEN source like '%yelp%' then 'Yelp'
    
    when ( source like '%facebook%' or  source ='fb') then 'Facebook'
    
    WHEN source like '%google%' then 'Google'
    WHEN source like '%twitter%' then 'Twitter'
    
    when source like '%mail%' then 'Email'
    WHEN source = 'Organic' then 'Organic'
	WHEN source = 'bing' then 'Bing'
    ELSE 'Other' END as channel2,
     u.id ,u.created_at
    from users u
    left join attributions a
    on u.attribution_id = a.id
    where u.kind='client' and u.created_at>=last_day(now())+interval 1 day-interval 7 month and  u.created_at<last_day(now())+interval 1 day) a 
    GROUP BY
     date,channel2