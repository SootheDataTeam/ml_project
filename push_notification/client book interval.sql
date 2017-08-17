select user_id,
date((convert_tz(session_time,'UTC',
                 case timezone when 'Pacific Time (US & Canada)' 
                 then 'America/Los_Angeles' 
                 else timezone end))) as session_date

from appointment_requests ar
where ar.status in ('completed')
and year((convert_tz(session_time,'UTC',
                     case timezone when 'Pacific Time (US & Canada)' 
                     then 'America/Los_Angeles' 
                     else timezone end)))>=2013
and (convert_tz(session_time,'UTC',
                case timezone when 'Pacific Time (US & Canada)' 
                then 'America/Los_Angeles' 
                else timezone end)) is not null
order by user_id, 
date((convert_tz(session_time,'UTC',
                 case timezone when 'Pacific Time (US & Canada)' 
                 then 'America/Los_Angeles' 
                 else timezone end))) asc


