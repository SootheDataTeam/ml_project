#client_last_session_date
select user_id,
	case timezone
	when 'Europe/London' then
	date(max(CONVERT_TZ(session_time,'UTC','Europe/London')))
	when 'Australia/Sydney' then
	date(max(CONVERT_TZ(session_time,'UTC','Australia/Sydney')))
	when 'America/Chicago' then
	date(max(CONVERT_TZ(session_time,'UTC','America/Chicago')))
	when 'America/New_York' then
	date(max(CONVERT_TZ(session_time,'UTC','America/New_York')))
	when 'America/Phoenix' then
	date(max(CONVERT_TZ(session_time,'UTC','America/Phoenix')))
	when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
	date(max(CONVERT_TZ(session_time,'UTC','America/Los_Angeles')) ) end as most_recent_booking
    from appointment_requests ar
    where status='completed' 
    group by user_id
