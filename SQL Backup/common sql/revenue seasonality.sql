
set @w=0, @d='',@crd=0;

 select a.*,@crd:=@w,floor(if(@d=week_num,@crd,@w:=@w+1)/7)+1 as wn,@d:=week_num
from
(select week_num,client_rank,sum(revenue) as revenue

from
((select date(convert_tz(session_time,'UTC',timezone)) as week_num, 'AAA,AA' as client_rank, sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue,week(convert_tz(session_time,'UTC',timezone)) as wn,year(convert_tz(session_time,'UTC',timezone)) as yo

from appointment_requests ar

join (select user_id,status from user_scores where user_score_type_id=4 and status <>'None') uc on uc.user_id=ar.user_id 

where ar.status='completed' and date(convert_tz(session_time,'UTC',timezone))>=date(now()-interval 1 year-interval weekday(now()-interval 1 year) day) and  uc.status in ('AAA','AA')

group by week_num)
union all

(select date(convert_tz(session_time,'UTC',timezone)) as week_num, 'A,B'
as client_rank, sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue,week(convert_tz(session_time,'UTC',timezone)) as wn,year(convert_tz(session_time,'UTC',timezone)) as yo

from appointment_requests ar

join (select user_id,status from user_scores where user_score_type_id=4 and status <>'None') uc on uc.user_id=ar.user_id 

where ar.status='completed' and date(convert_tz(session_time,'UTC',timezone))>=date(now()-interval 1 year-interval weekday(now()-interval 1 year) day) and uc.status in ('A','B')

group by week_num)

union all

(select date(convert_tz(session_time,'UTC',timezone)) as week_num,'C'
as client_rank, sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue,week(convert_tz(session_time,'UTC',timezone)) as wn,year(convert_tz(session_time,'UTC',timezone)) as yo

from appointment_requests ar

join (select user_id,status from user_scores where user_score_type_id=4 and status <>'None') uc on uc.user_id=ar.user_id 

where ar.status='completed' and date(convert_tz(session_time,'UTC',timezone))>=date(now()-interval 1 year-interval weekday(now()-interval 1 year) day) and uc.status not in ('AAA','AA','A','B')

group by week_num))a
group by week_num,client_rank)a  