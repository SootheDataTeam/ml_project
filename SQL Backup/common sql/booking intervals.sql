
select u.id,timestampdiff(day,u.created_at,ar.ft_session) as interval_to_book


from users u 

join (select user_id,min(session_time) as ft_session from appointment_requests ar where ar.status='completed' group by user_id)  ar on ar.user_id=u.id
 where ft_session>=now()-interval 12 month
 
 
 ########
 
 set @c_user='',@rank=0;
 
 select f1.user_id,timestampdiff(day,f1.session_time,f2.session_time) as interval_between_bookings,us.status as rank
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
 
 join
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

 
 #####
 
 
 
select u.id,timestampdiff(day,u.created_at,ar.ft_session) as interval_to_book,uc.status as rank


from users u 
join (select user_id,status from user_scores where user_score_type_id=4 )uc on uc.user_id=u.id

join (select user_id,min(created_at) as ft_session from appointment_requests ar where ar.status='completed' group by user_id)  ar on ar.user_id=u.id
 where ft_session>=now()-interval 12 month  
 
####

set @c_user='',@rank=0;
 
 select rank,sum(case when interval_between_bookings=0 then 1 else 0 end) as booked_with_same_day, sum(same_session_time) as booked_two_same_time,count(*) as num_client
 from
 (select f1.user_id,timestampdiff(day,f1.session_time,f2.session_time) as interval_between_bookings,us.status as rank,if(f1.session_time=f2.session_time,1,0) as same_session_time
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
 
 join
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

where f1.user_id in  ( select user_id from (select user_id,min(session_time) as ft_session from appointment_requests where status='completed' group by user_id)a where ft_session>=now()-interval 12 month) )a

group by rank 
 
 
 
 ###
 select dayname(created_at) as day,dayofweek(created_at) as dn,count(*)
 
 from users u 
 
 
 where kind='client' and u.id in  ( select user_id from (select user_id,min(session_time) as ft_session from appointment_requests where status='completed' group by user_id)a where ft_session>=now()-interval 12 month)
 
 group by day
 order by dn
 
 
