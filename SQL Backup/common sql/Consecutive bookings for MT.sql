set @group='', @row = 0;


select therapist_id,max(rank) as num_longest
from
(select therapist_id,case when status!='cancelled' then @row:=if(@group=therapist_id ,@row+1,1) else @row:=0 end as rank,status,@group:=therapist_id
from
(select therapist_id,a.status,session_time
from appointments a

where a.status in ('complete','reviewed','cancelled') and session_time>=now()-interval 3 month
order by therapist_id,session_time)a)a1



group by therapist_id



#####

set @group='', @row = 0, @bucket=0;


select therapist_id,avg(consec_bookings) as avg_consecutive_bookings
from
(select therapist_id,bk,max(rank)  as consec_bookings
from
 (select therapist_id,case when status!='cancelled' then @row:=if(@group=therapist_id ,@row+1,1) else @row:=0 end as rank,@bucket:=if( @group=therapist_id and @row>0,@bucket,@bucket+1)as bk,status,@group:=therapist_id
from
(select therapist_id,a.status,session_time
from appointments a

where a.status in ('complete','reviewed','cancelled') and therapist_id=635
order by therapist_id,session_time
)a )a1

where rank>0

group by therapist_id,bk) a2
group by therapist_id


#####

set @group='', @row = 0, @bucket=0;



select a.id as MT_id,a.name,a.city,a.completed_sessions,a3.consecutive_bookings_record,a3.avg_consecutive_bookings
from
(select u.id,concat(u.first_name,' ',u.last_name) as name,city,count(*) as completed_sessions

from appointments a
join users u on u.id=a.therapist_id
where a.status in ('complete','reviewed') and session_time>=now()-interval 3 month and u.kind='therapist'

group by u.id
having completed_sessions>=1)a

join
(select therapist_id,round(avg(consec_bookings),1) as avg_consecutive_bookings,max(consec_bookings) as consecutive_bookings_record
from
(select therapist_id,bk,max(rank)  as consec_bookings
from
 (select therapist_id,case when status!='cancelled' then @row:=if(@group=therapist_id ,@row+1,1) else @row:=0 end as rank,@bucket:=if( @group=therapist_id and @row>0,@bucket,@bucket+1)as bk,status,@group:=therapist_id
from
(select therapist_id,a.status,session_time
from appointments a

where a.status in ('complete','reviewed','cancelled') and session_time>=now()-interval 3 month
order by therapist_id,session_time
)a )a1

where rank>0

group by therapist_id,bk) a2
group by therapist_id) a3 on a.id=a3.therapist_id

order by a.city,a.completed_sessions desc

