#therapist_last_session
select therapist_id,
	case ar.timezone
		when 'Europe/London' then
		date(max(CONVERT_TZ(ar.session_time,'UTC','Europe/London')))
		when 'Australia/Sydney' then
		date(max(CONVERT_TZ(ar.session_time,'UTC','Australia/Sydney')))
		when 'America/Chicago' then
		date(max(CONVERT_TZ(ar.session_time,'UTC','America/Chicago')))
		when 'America/New_York' then
		date(max(CONVERT_TZ(ar.session_time,'UTC','America/New_York')))
		when 'America/Phoenix' then
		date(max(CONVERT_TZ(ar.session_time,'UTC','America/Phoenix')))
		when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
		date(max(CONVERT_TZ(ar.session_time,'UTC','America/Los_Angeles')) ) end as most_recent_session
	from appointment_requests ar
	join appointments a on a.appointment_request_id=ar.id
	where a.status in ('complete','reviewed')
	group by therapist_id