SELECT
	user_id,
	status,
	MAX(CASE WHEN RANK=1 THEN request_time END) AS book_time_1,
	MAX(CASE WHEN RANK=2 THEN request_time END) AS book_time_2,
	MAX(CASE WHEN RANK=3 THEN request_time END) AS book_time_3,
	MAX(CASE WHEN RANK=1 THEN session_time END) AS appt_time_1,
	MAX(CASE WHEN RANK=2 THEN session_time END) AS appt_time_2,
	MAX(CASE WHEN RANK=3 THEN session_time END) AS appt_time_3,
	MAX(CASE WHEN session_type='deep' THEN 1 ELSE 0 END) AS type_deep,
	MAX(CASE WHEN session_type='swedish' THEN 1 ELSE 0 END) AS type_swedish,
	MAX(CASE WHEN session_type='prenatal' THEN 1 ELSE 0 END) AS type_prenatal,
	MAX(CASE WHEN session_type='sports' THEN 1 ELSE 0 END) AS type_sports,
	MAX(CASE WHEN session_type='couples' THEN 1 ELSE 0 END) AS type_couples,
	MAX(CASE WHEN session_length=60 THEN 1 ELSE 0 END) AS length_60,
	MAX(CASE WHEN session_length=90 THEN 1 ELSE 0 END) AS length_90,
	MAX(CASE WHEN session_length=120 THEN 1 ELSE 0 END) AS length_120,
	MAX(CASE WHEN requested_therapist=1 THEN 1 ELSE 0 END) AS special_request,
	MAX(CASE WHEN is_unfilled=1 THEN 1 ELSE 0 END) AS unfilled
	FROM
	(SELECT
	ar.user_id, uscore.status, rank,
	convert_tz(ar.created_at,'UTC',timezone) request_time, 
	convert_tz(session_time,'UTC',timezone) session_time, 
	weekday(convert_tz(session_time,'UTC',timezone)) ar_day_of_week,
	hour(convert_tz(session_time,'UTC',timezone)) ar_hour,
	session_type, appointment_type, session_length,
	CASE WHEN therapist_id IS NOT NULL THEN 1 ELSE 0 END AS requested_therapist,
	is_unfilled
	from appointment_requests ar
	JOIN
	(SELECT user_id, id ar_id, rank
		FROM
		(SELECT id, user_id, created_at, 
			   (CASE user_id 
				WHEN @curUser
				THEN @curRow := @curRow + 1
				ELSE @curRow := 1 AND @curUser := user_id END) as Rank
		FROM 
		(
			SELECT @curRow:=0, @curUser:='') as R,
		(
			SELECT ar.id, ar.user_id, ar.created_at 
			FROM appointment_requests ar
			WHERE (ar.status='completed' or ar.status='filled')
			ORDER BY ar.user_id, ar.created_at
			) AS TEMP ) ar1
			WHERE rank < 4) ar_rank ON (ar.id=ar_rank.ar_id)
	JOIN user_scores uscore ON (ar.user_id=uscore.user_id)
	LEFT JOIN therapist_preferences ON (appointment_request_id=ar.id)
	GROUP BY 1,2
    ) first_three;