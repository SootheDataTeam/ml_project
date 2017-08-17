 set @c_user='',@rank=0;
 
 select f1.user_id,timestampdiff(day,f1.session_time,f2.session_time) as interval_between_bookings,ifnull(timestampdiff(day,f1.session_time,f2.session_time),timestampdiff(day,f1.session_time,now()))as not_book_interval ,us.status as rank
 from
 (
 select user_id,rank,session_time
 from
 (select user_id,if(@c_user=user_id,@rank:=@rank+1,@rank:=1) as rank, @c_user:=user_id,session_time
 from
 (select user_id,session_time
 
 
 from appointment_requests
 where status='completed'
 
 order by user_id,session_time)a)a
 where rank=2 )f1
 
 left join
  (
  select user_id,rank,session_time
  from
  (select user_id,if(@c_user=user_id,@rank:=@rank+1,@rank:=1) as rank, @c_user:=user_id,session_time
 from
 (select user_id,session_time
 
 
 from appointment_requests
 where status='completed'
 
 order by user_id,session_time)a)a
 where rank=3)f2 on f1.rank=f2.rank-1 and f1.user_id=f2.user_id
 join (select user_id,status from user_scores where user_score_type_id=4)us on us.user_id=f1.user_id
 

where f1.user_id in  ( select user_id from (select user_id,min(session_time) as ft_session from appointment_requests where status='completed' group by user_id)a where ft_session>=now()-interval 12 month)
