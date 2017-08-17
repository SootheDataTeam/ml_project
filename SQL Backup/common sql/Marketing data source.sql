set @group='', @row = 0;
select tx3.*,ifnull(timestampdiff(day,tx3.ar_created_at,tx2.ar_created_at),0)  as Gap
from 
(select tx.*, @row:=if(@group=tx.user_id,@row+1,1) as rank, @group:=tx.user_id
from (
select ar.id, ar.user_id, date(ar.created_at) as ar_created_at, ar.status, ar.attribution_id,ar.city_id
from appointment_requests ar


where 
(ar.status = 'completed')
order by user_id,ar_created_at

) as tx ) as tx3
join 

(select tx1.*, @row:=if(@group=tx1.user_id,@row+1,1) as rank, @group:=tx1.user_id
from (
select ar.id, ar.user_id, date(ar.created_at) as ar_created_at, ar.status, ar.attribution_id 
from appointment_requests ar


where 
(ar.status = 'completed')
order by user_id,ar_created_at

) as tx1) tx2  on tx2.user_id=tx3.user_id and tx2.rank-tx3.rank=1
