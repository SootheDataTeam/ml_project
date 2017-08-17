 set @group='', @row = 0;
select m.city,sum(case when ar.last_booking>cl.session_time and rank=1 then 1 else 0 end)/sum(case when rank=1 then 1 else 0 end) as booking_ratio_cancelled_1st, 
sum(case when ar.last_booking>cl.session_time and rank=2 then 1 else 0 end)/sum(case when rank=2 then 1 else 0 end) as booking_ratio_cancelled_2nd,
sum(case when ar.last_booking>cl.session_time and rank=3 then 1 else 0 end)/sum(case when rank=3 then 1 else 0 end) as booking_ratio_cancelled_3rd,
sum(case when ar.last_booking>cl.session_time and rank=4 then 1 else 0 end)/sum(case when rank=4 then 1 else 0 end) as booking_ratio_cancelled_4th


from
(select user_id, max(session_time) as last_booking,timezone from appointment_requests where status='completed' group by user_id) ar
join
(select user_id,rank,session_time
from
 (select user_id,@row:=if(@group=user_id,@row+1,1) as rank, @group:=user_id,session_time
 from appointment_requests ar
 where ar.status='cancelled' and is_unfilled=True
 order by user_id,session_time) ar 
where rank<=4

) cl on cl.user_id=ar.user_id 

join (select user_id,city from (select user_id,count(*) as cnt,c.name as city from appointment_requests ar join cities c on c.id=ar.city_id where status='completed' group by user_id,city order by cnt desc)a group by user_id) m on m.user_id=cl.user_id
 group by  m.city
 
 
 
 ####test
  set @group='', @row = 0;
  
 select user_id,rank,session_time
from
 (select user_id,@row:=if(@group=user_id,@row+1,1) as rank, @group:=user_id,session_time
 from appointment_requests ar
 where ar.status='cancelled' and is_unfilled=True
 order by user_id,session_time) ar 
where rank<=4