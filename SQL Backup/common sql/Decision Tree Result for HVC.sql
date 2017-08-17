
set @group='', @row = 0;

select user_id,concat(u.first_name,' ', u.last_name) as name,a.status as current_group,'High Value Client Projected' 
from
(SELECT
	user_id,
	status,
	max(CASE WHEN RANK=1 THEN request_time END) AS book_time_1,
	max(CASE WHEN RANK=2 THEN request_time END) AS book_time_2,
	max(CASE WHEN RANK=3 THEN request_time END) AS book_time_3,
	max(CASE WHEN RANK=1 THEN session_time END) AS appt_time_1,
	max(CASE WHEN RANK=2 THEN session_time END) AS appt_time_2,
	max(CASE WHEN RANK=3 THEN session_time END) AS appt_time_3,
	max(CASE WHEN session_type='deep' THEN 1 ELSE 0 END) AS type_deep,
	max(CASE WHEN session_type='swedish' THEN 1 ELSE 0 END) AS type_swedish,
	max(CASE WHEN session_type='prenatal' THEN 1 ELSE 0 END) AS type_prenatal,
	max(CASE WHEN session_type='sports' THEN 1 ELSE 0 END) AS type_sports,
	max(CASE WHEN session_type='couples' THEN 1 ELSE 0 END) AS type_couples,
	max(CASE WHEN session_length=60 THEN 1 ELSE 0 END) AS length_60,
	max(CASE WHEN session_length=90 THEN 1 ELSE 0 END) AS length_90,
	max(CASE WHEN session_length=120 THEN 1 ELSE 0 END) AS length_120,
	max(CASE WHEN requested_therapist=1 THEN 1 ELSE 0 END) AS special_request,
	max(CASE WHEN is_unfilled=1 THEN 1 ELSE 0 END) AS unfilled,count(*) as session_cnt
	FROM
	(SELECT
	ar.user_id, uscore.status,  
    @row:=if(@group=ar.user_id,@row+1,1) as RANK, @group:=ar.user_id ,
	convert_tz(ar.created_at,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end) request_time, 
	convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end) session_time, 
	weekday(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) ar_day_of_week,
	hour(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) ar_hour,
	session_type, appointment_type, session_length,
	CASE WHEN ar.id in (select distinct(appointment_request_id) from therapist_preferences) THEN 1 ELSE 0 END AS requested_therapist,
	is_unfilled
	from appointment_requests ar
	 
	JOIN user_scores uscore ON (ar.user_id=uscore.user_id)
	 where uscore.user_score_type_id=4 and ar.status in ('completed')

    order by ar.user_id,session_time
     
    ) first_three
    where RANK<6
    group by user_id)a
    
join users u on u.id=a.user_id

where timestampdiff(day,appt_time_1,book_time_2)<21 and session_cnt>1 and 
(length_90=1 or length_120=1 or special_request=1 or ( timestampdiff(minute,book_time_1,appt_time_1)<90 and timestampdiff(minute,book_time_2,appt_time_2)<90 ) or (u.estimated_gender='male' and type_sports=1)) and a.status not in ('AA','AAA')
  