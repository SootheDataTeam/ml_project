set @group='', @row = 0;

select us.status,booking_number,avg(Gap) as avg_gap
from
(select tx3.user_id,tx3.ar_session_time, tx3.rank as booking_number,ifnull(timestampdiff(day,tx2.ar_session_time,tx3.ar_session_time),0)  as Gap
from 
(select tx.*, @row:=if(@group=tx.user_id,@row+1,1) as rank, @group:=tx.user_id
from (
select ar.id, ar.user_id, date(ar.session_time) as ar_session_time, ar.status, ar.city_id
from appointment_requests ar


where 
(ar.status = 'completed') 
order by user_id,ar_session_time

) as tx ) as tx3
join 

(select tx1.*, @row:=if(@group=tx1.user_id,@row+1,1) as rank, @group:=tx1.user_id
from (
select ar.id, ar.user_id, date(ar.session_time) as ar_session_time, ar.status
from appointment_requests ar


where 
(ar.status = 'completed')  
order by user_id,ar_session_time

) as tx1) tx2  on tx2.user_id=tx3.user_id and tx2.rank-tx3.rank=-1) ar

join  (select user_id,status from user_scores where user_score_type_id=4   ) us on us.user_id=ar.user_id 
where Gap<timestampdiff(day,'2013-08-01',now())
group by us.status,booking_number

####
select status,count(*)

from user_scores

where user_score_type_id=4
group by status  

####

select us.status,count(*) as revenue,count(*)/count(distinct(ar.user_id)) as Avg_bookings,count(distinct(ar.user_id)) as clients_cnt

from appointment_requests ar
join  (select user_id,status from user_scores where user_score_type_id=4  and status not in ('None') ) us on us.user_id=ar.user_id 
where ar.status='completed'
group by us.status

