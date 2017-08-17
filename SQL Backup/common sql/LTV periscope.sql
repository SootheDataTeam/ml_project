select g.city, avg(avg_bycity_byactivation) as LTV 
from 
(select city,activation_date,sum(avg_amount)/count(distinct(user_id)) as avg_bycity_byactivation,count(distinct(user_id))
from 
(
select ar.user_id, sum(total_spend) as avg_amount,date_format(first_activation,'%Y-%m') as activation_date,city
from appointment_requests ar
join
(select ar.user_id,min(ar.created_at) as first_activation,date_format(min(ar.created_at),'%Y-%m') as date,c.name as city
from appointment_requests ar
left join cities c on c.id=ar.city_id
where ar.status='completed' 
group by ar.user_id) f on f.user_id=ar.user_id
where  ar.status='completed'and first_activation>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month and session_time>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month
group by ar.user_id
)m 
where city is not null
group by city,activation_date) g

group by g.city
 
 
select ar.user_id,timestampdiff(month,first_activation,ar.session_time) as cohort_month, sum(total_spend) as avg_amount,date_format(first_activation,'%Y-%m') as activation_date,city
from appointment_requests ar
join
(select ar.user_id,min(ar.created_at) as first_activation,date_format(min(ar.created_at),'%Y-%m') as date,c.name as city
from appointment_requests ar
left join cities c on c.id=ar.city_id
where ar.status='completed' 
group by ar.user_id) f on f.user_id=ar.user_id
where  ar.status='completed'and first_activation>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month and session_time>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month
group by ar.user_id,cohort_month
 


#####modified
select f.city, sum(LTV_cohort) as LTV
from
(select s.city,s.cohort_month,avg(avg_cohort_month) as LTV_cohort
from 
(select g.city,g.activation_date,g.cohort_month,sum_by_cohort / user_activation_month as avg_cohort_month
from
(select city,activation_date,cohort_month,sum(avg_amount) as sum_by_cohort 
from 
(
select ar.user_id,timestampdiff(month,first_activation,ar.session_time) as cohort_month, sum(total_spend) as avg_amount,date_format(first_activation,'%Y-%m') as activation_date,city
from appointment_requests ar
join
(select ar.user_id,min(ar.created_at) as first_activation,date_format(min(ar.created_at),'%Y-%m') as date,c.name as city
from appointment_requests ar
left join cities c on c.id=ar.city_id
where ar.status='completed' 
group by ar.user_id) f on f.user_id=ar.user_id
where  ar.status='completed'and first_activation>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month and session_time>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month
group by ar.user_id,cohort_month
)m 
where city is not null
group by city,activation_date,cohort_month) g


join (select city,activation_date,count(distinct(user_id)) as user_activation_month
from 
(
select ar.user_id,timestampdiff(month,first_activation,ar.session_time) as cohort_month, sum(total_spend) as avg_amount,date_format(first_activation,'%Y-%m') as activation_date,city
from appointment_requests ar
join
(select ar.user_id,min(ar.created_at) as first_activation,date_format(min(ar.created_at),'%Y-%m') as date,c.name as city
from appointment_requests ar
left join cities c on c.id=ar.city_id
where ar.status='completed' 
group by ar.user_id) f on f.user_id=ar.user_id
where  ar.status='completed'and first_activation>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month and session_time>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month
group by ar.user_id,cohort_month
)m 
where city is not null
group by city,activation_date)  w on w.activation_date=g.activation_date

group by g.city,g.activation_date,g.cohort_month) s 

group by s.city,s.s.cohort_month) f

group by f.city


###### by city

select f.city, sum(LTV_cohort) as LTV
from
(select s.city,s.cohort_month,avg(avg_cohort_month) as LTV_cohort
from 
(
select g.city,g.activation_date,g.cohort_month,sum_by_cohort / user_activation_month as avg_cohort_month
from
(select city,activation_date,cohort_month,sum(avg_amount) as sum_by_cohort 
from 
(
select ar.user_id,timestampdiff(month,first_activation,ar.session_time) as cohort_month, sum(total_spend) as avg_amount,date_format(first_activation,'%Y-%m') as activation_date,city
from appointment_requests ar
join
(select ar.user_id,min(ar.created_at) as first_activation,date_format(min(ar.created_at),'%Y-%m') as date,c.name as city 
from appointment_requests ar
left join cities c on c.id=ar.city_id
where ar.status='completed'  
group by ar.user_id) f on f.user_id=ar.user_id   
where  ar.status='completed'and first_activation>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month and session_time>=last_day(now()) +interval 1 day - interval 13 month and session_time<last_day(now()) +interval 1 day - interval 1 month
group by ar.user_id,cohort_month
)m 
where city is not null
group by city,activation_date,cohort_month) g


join (select city,activation_date,count(distinct(user_id)) as user_activation_month
from 
(
select ar.user_id,timestampdiff(month,first_activation,ar.session_time) as cohort_month, sum(total_spend) as avg_amount,date_format(first_activation,'%Y-%m') as activation_date,city
from appointment_requests ar
join
(select ar.user_id,min(ar.created_at) as first_activation,date_format(min(ar.created_at),'%Y-%m') as date,c.name as city 
from appointment_requests ar
left join cities c on c.id=ar.city_id
where ar.status='completed'  
group by ar.user_id) f on f.user_id=ar.user_id  
where  ar.status='completed'and first_activation>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month and session_time>=last_day(now()) +interval 1 day - interval 13 month and session_time<last_day(now()) +interval 1 day - interval 1 month
group by ar.user_id,cohort_month
)m 
where city is not null
group by city,activation_date)  w on w.activation_date=g.activation_date and w.city=g.city) s
where s.cohort_month>=0
group by s.city,s.s.cohort_month) f
group by f.city


####by attribution

select f.source, sum(LTV_cohort) as LTV
from
(select s.source,s.cohort_month,avg(avg_cohort_month) as LTV_cohort
from 
(

select g.source,g.activation_date,g.cohort_month,sum_by_cohort / user_activation_month as avg_cohort_month
from
(select source,activation_date,cohort_month,sum(avg_amount) as sum_by_cohort 
from 
(
select ar.user_id,timestampdiff(month,first_activation,ar.session_time) as cohort_month, sum(total_spend) as avg_amount,date_format(first_activation,'%Y-%m') as activation_date,
case when f1.source like 'yelp%' then 'Yelp'
when f1.source like 'yelp%' then 'Yelp'
when (f1.source like '%facebook%' or f1.source ='fb') then 'Facebook'
when f1.source like 'ROI%' then 'ROI'
when f1.source like '%facebook%' then 'ROI'
when f1.source like '%google%' then 'Google'
when f1.source like '%twitter%' then 'Twitter'
when f1.source like '%instagram%' then 'Instagram'
when f1.source like '%mail%' then 'Email'
when f1.source  ='Organic' then 'Organic'
when f1.source  ='bing' then 'Bing'
else   'other' end as source 
from appointment_requests ar
join
(select ar.user_id,min(ar.created_at) as first_activation,att.source
from appointment_requests ar
join (select ar.user_id, min(ar.created_at), source from attributions att join appointment_requests ar on att.id=ar.attribution_id  where ar.status='completed' group by ar.user_id)att on att.user_id=ar.user_id
where ar.status='completed'   
group by ar.user_id) f1 on f1.user_id=ar.user_id
  
where   ar.status='completed'and first_activation>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month and session_time>=last_day(now()) +interval 1 day - interval 13 month and session_time<last_day(now()) +interval 1 day - interval 1 month
group by ar.user_id,cohort_month
)m 
 
group by source,activation_date,cohort_month) g


join (select source,activation_date,count(distinct(user_id)) as user_activation_month
from 
(
select ar.user_id,timestampdiff(month,first_activation,ar.session_time) as cohort_month, sum(total_spend) as avg_amount,date_format(first_activation,'%Y-%m') as activation_date,
case when f1.source like 'yelp%' then 'Yelp'
when f1.source like 'yelp%' then 'Yelp'
when (f1.source like '%facebook%' or f1.source ='fb') then 'Facebook'
when f1.source like 'ROI%' then 'ROI'
when f1.source like '%facebook%' then 'ROI'
when f1.source like '%google%' then 'Google'
when f1.source like '%twitter%' then 'Twitter'
when f1.source like '%instagram%' then 'Instagram'
when f1.source like '%mail%' then 'Email'
when f1.source  ='Organic' then 'Organic'
when f1.source  ='bing' then 'Bing'
else   'other' end as source 
from appointment_requests ar
join
(select ar.user_id,min(ar.created_at) as first_activation, att.source
from appointment_requests ar
 join (select ar.user_id, min(ar.created_at), source from attributions att join appointment_requests ar on att.id=ar.attribution_id  where ar.status='completed'  group by ar.user_id) att on att.user_id=ar.user_id
where ar.status='completed'   
group by ar.user_id) f1 on f1.user_id=ar.user_id  

where    ar.status='completed'and first_activation>=last_day(now()) +interval 1 day - interval 13 month and first_activation<=last_day(now()) +interval 1 day - interval 1 month and session_time>=last_day(now()) +interval 1 day - interval 13 month and session_time<last_day(now()) +interval 1 day - interval 1 month
group by ar.user_id,cohort_month
)m 
 
group by source,activation_date)  w on w.activation_date=g.activation_date and w.source=g.source) s
where s.cohort_month>=0  
 
group by s.source,s.s.cohort_month) f
group by f.source
