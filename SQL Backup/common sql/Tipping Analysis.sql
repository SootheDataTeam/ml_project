

select c.name as city,sum(case when t.amount>0 and r.value >=4 then 1 else 0 end) as tipped,sum(case when r.value is not null then 1 else 0 end) as reviewed,sum(case when r.value >=4 then 1 else 0 end) as well_reviewed 
,count(*) as total_appointment, avg(timestampdiff(day,a.session_time,r.updated_at)),sum(case when ar.session_length=60 then 1 else 0 end) as sixtymin_session,sum(case when ar.session_length=90 then 1 else 0 end) as nintymin_session
,sum(case when ar.session_length=120 then 1 else 0 end) as twohour_session,sum(case when t.amount>0 and r.value >=4 then t.amount else 0 end)/count(*) as avg_tip,sum(ifnull(t.amount,0))/count(*) as avg_tip2

from appointments a
join appointment_requests ar on ar.id=a.appointment_request_id
left join (select * from reviews where recipient_id=therapist_id) r on r.appointment_id=a.id
left join tips t on t.appointment_id=a.id
join cities c on c.id=ar.city_id
where a.status in ('complete','reviewed') and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>='2017-02-27' and ar.city_id in (31 ,38, 18) and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<'2017-03-27'
group by city 

select timestampdiff(day,'2017-01-30','2017-02-26')

#####

select c.name as city,sum(case when t.amount>0 then 1 else 0 end) as tipped,sum(case when r.value is not null then 1 else 0 end) as reviewed,sum(case when r.value >=4 then 1 else 0 end) as well_reviewed ,count(*) as total_appointment,avg(timestampdiff(day,a.session_time,r.updated_at)),sum(case when r.value is not null then 1 else 0 end) /count(*)

from appointments a
join appointment_requests ar on ar.id=a.appointment_request_id
left join (select * from reviews where recipient_id=therapist_id) r on r.appointment_id=a.id
left join tips t on t.appointment_id=a.id
join cities c on c.id=ar.city_id
where a.status in ('complete','reviewed') and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<'2017-02-27' and ar.city_id in (31 ,38, 18) and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>'2017-01-29' 
group by city 



###### productivity comparison

###after
select c.name as city,count(*)/count(distinct(a.therapist_id)),count(*)

from appointments a
join appointment_requests ar on ar.id=a.appointment_request_id

join cities c on c.id=ar.city_id
where a.status in ('complete','reviewed') and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>='2017-02-27' and ar.city_id in (31 ,38, 18) and a.therapist_id in (select distinct(therapist_id) from appointments where status in ('complete','reviewed') and date(session_time)<='2017-02-27')
and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<='2017-03-12'
group by city 


##before

select c.name as city,count(*)/count(distinct(a.therapist_id)),count(*)

from appointments a
join appointment_requests ar on ar.id=a.appointment_request_id

join cities c on c.id=ar.city_id
where a.status in ('complete','reviewed') and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<'2017-02-27' and ar.city_id in (31 ,38, 18) and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>='2017-02-12' 
and  a.therapist_id in (select distinct(therapist_id) from appointments where status in ('complete','reviewed') and date(session_time)<='2017-02-27') and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))!='2017-02-14'
group by city 



### fill rate comparison
###after
select c.name as city, sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate

from   appointment_requests ar  

join cities c on c.id=ar.city_id
where( ar.status='completed' or (ar.status='cancelled' and ar.is_unfilled=True))  and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>='2017-02-27' and ar.city_id in (31 ,38, 18) 
and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<'2017-03-27'
group by city 


###before

select c.name as city, sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate

from   appointment_requests ar  

join cities c on c.id=ar.city_id
where( ar.status='completed' or (ar.status='cancelled' and ar.is_unfilled=True))  and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>='2017-01-30' and ar.city_id in (31 ,38, 18) 
and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<'2017-02-27'
group by city 

#####
###after
select date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as date, sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate

from   appointment_requests ar  

 
where( ar.status='completed' or (ar.status='cancelled' and ar.is_unfilled=True))  and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>='2017-02-27' and ar.city_id in (31 ,38, 18) 
and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<'2017-03-27'
group by date 


#####before

select date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as date, sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate

from   appointment_requests ar  

 
where( ar.status='completed' or (ar.status='cancelled' and ar.is_unfilled=True))  and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>='2017-02-13' and ar.city_id in (31 ,38, 18) 
and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<'2017-02-27'
group by date




select * from tips







select * from earnings where appointment_id=360317


#####
select ar.id,(case when t.amount>0 then 1 else 0 end) as tipped

from   appointment_requests ar  
 
left join tips t on t.appointment_request_id=ar.id
where ar.status in ('completed' ) and date(ar.session_time)>='2017-02-16' and ar.city_id=31  

select * from users where pay_level=2

 select * from earnings where therapist_id=217440 and date(created_at)>'2017-02-16'
 
 
 
#### new pay vs old pay
select nw.therapist_id,nw.payout as new_payout,od.payout as old_payout

from
(select a.therapist_id, sum(e.amount) as payout

from appointments a
join users u on u.id=a.therapist_id
join earnings e on  e.appointment_id=a.id
join appointment_requests ar on ar.id=a.appointment_request_id 
where a.status in ('complete','reviewed') and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>'2017-02-27' and u.city ='Las Vegas' and e.status='paid'

group by a.therapist_id) as nw

join 
(select therapist_id,
sum( case when amount=55  then 60 
when  amount=80 then 90
when amount=105 then 120
when amount=65  then 70 
when  amount=90 then 100
when amount=115 then 130
else amount
end
 ) as payout
from
(select a.therapist_id, a.id,sum(e.amount) as amount

from appointments a
 join users u on u.id=a.therapist_id
join earnings e on  e.appointment_id=a.id
join appointment_requests ar on ar.id=a.appointment_request_id
where a.status in ('complete','reviewed') and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>'2017-02-27' and u.city ='Las Vegas' and e.status='paid' and e.tip_id is null  

group by a.therapist_id,a.id)a 

group by therapist_id) as od on nw.therapist_id=od.therapist_id


#### group by day

select nw.date,nw.payout as new_payout,od.payout as old_payout
from
(select date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as date, sum(e.amount) as payout

from appointments a
join users u on u.id=a.therapist_id
join appointment_requests ar on ar.id=a.appointment_request_id
join earnings e on  e.appointment_id=a.id
 
where a.status in ('complete','reviewed') and  ar.city_id=31 and e.status='paid' 

group by date) as nw

join 
(select date,
sum( case when amount=55  then 60 
when  amount=80 then 90
when amount=105 then 120
when amount=65  then 70 
when  amount=90 then 100
when amount=115 then 130
else amount
end
 ) as payout
from
(select date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as date,a.therapist_id, ar.id,sum(e.amount) as amount

from appointments a
 join users u on u.id=a.therapist_id
join earnings e on  e.appointment_id=a.id
join appointment_requests ar on ar.id=a.appointment_request_id
where a.status in ('complete','reviewed') and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>'2017-02-27'  and e.status='paid' and e.tip_id is null  and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<='2017-03-12' 
and ar.city_id=31
group by date,a.therapist_id,ar.id)a 

group by date) as od on od.date=nw.date


####3
select sum(session_total_price+ifnull(gift_amount,0))  as revenue

from appointment_requests ar
where status='completed' and date(convert_tz(ar.session_time,'UTC',case ar.timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))='2017-02-16' and city_id=31


select * from earnings where therapist_id=171465

###### productivity test 

 select a.therapist_id,case when a.productivity>0 then 1 else 0 end as engaged
from users u 
left join
(select a.therapist_id, count(*)/(case when date(u.created_at)>'2016-12-31' then timestampdiff(day,date(u.created_at),'2017-03-01') else timestampdiff(day,'2017-01-01','2017-03-01') end) as productivity

from appointments a

join (select therapist_id,date(min(CONVERT_TZ(session_time,'UTC','US/Pacific'))) as ft from appointments where status in ('complete','reviewed') group by therapist_id having ft<'2017-02-27')a1 on a1.therapist_id=a.therapist_id
where  a.status in ('complete','reviewed') and u.city='Las Vegas' and date(a.session_time)<'2017-03-01' and date(a.session_time)>='2017-01-01'
group by therapist_id) a
 
###

select a.therapist_id, count(*)/( timestampdiff(day,'2017-03-01','2017-03-20')) as distinct_date

from appointments a
join users u on u.id=a.therapist_id 
join (select therapist_id,date(min(CONVERT_TZ(session_time,'UTC','US/Pacific'))) as ft from appointments where status in ('complete','reviewed') group by therapist_id having ft<'2017-02-27')a1 on a1.therapist_id=a.therapist_id
where  a.status in ('complete','reviewed') and u.city='Salt Lake City/Park City' and date(a.session_time)<'2017-03-20' and date(a.session_time)>='2017-03-01'
group by therapist_id

#####


select a.therapist_id, count(*)/(case when date(u.created_at)>'2017-01-31' then timestampdiff(day,date(u.created_at),'2017-02-20') else timestampdiff(day,'2017-02-01','2017-02-20') end) as distinct_date

from appointments a
join users u on u.id=a.therapist_id 
join (select therapist_id,date(min(CONVERT_TZ(session_time,'UTC','US/Pacific'))) as ft from appointments where status in ('complete','reviewed') group by therapist_id having ft<'2017-02-27')a1 on a1.therapist_id=a.therapist_id
where  a.status in ('complete','reviewed') and u.city='Salt Lake City/Park City' and date(a.session_time)<'2017-02-20' and date(a.session_time)>='2017-02-01'
group by therapist_id