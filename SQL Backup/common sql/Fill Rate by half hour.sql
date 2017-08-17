 (select date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as local_date,CONCAT(CAST(HOUR(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) AS CHAR(2)),
 ':', 
 (CASE WHEN MINUTE(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) < 30 THEN '00' ELSE '30' END),
 ' - ',CAST(HOUR(convert_tz(session_time+interval 30 minute,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) AS CHAR(2)),
 ':', 
 (CASE WHEN MINUTE(convert_tz(session_time+interval 30 minute,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) < 30 THEN '00' ELSE '30' END)
 ) AS hour,sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate


from appointment_requests ar

where (ar.status = 'completed' or (ar.status='cancelled' and is_unfilled=1)) and date_format(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end),'%Y-%m')=date_format(convert_tz(now(),'UTC','US/Pacific'),'%Y-%m') and   HOUR(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) not in (1,2,3,4,5,6,7)

group by local_date, hour

order by local_date,HOUR(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)),MINUTE(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) asc)

union 

(select date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as local_date,sum(case when status='completed' then 1 else 0 end)/count(*) as fill_rate

from appointment_requests ar

where (ar.status = 'completed' or (ar.status='cancelled' and is_unfilled=1)) and date_format(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end),'%Y-%m')=date_format(convert_tz(now(),'UTC','US/Pacific'),'%Y-%m')

group by local_date
order by local_date

)



####
