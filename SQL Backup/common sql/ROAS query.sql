##booking data
select case u.time_zone
when 'Europe/London' then
date_format(date(CONVERT_TZ(u.created_at,'UTC','Europe/London')),'%Y-%m-%d')
when 'America/Chicago' then
date_format(date(CONVERT_TZ(u.created_at,'UTC','America/Chicago')),'%Y-%m-%d')
when 'America/New_York' then
date_format(date(CONVERT_TZ(u.created_at,'UTC','America/New_York')),'%Y-%m-%d')
when 'America/Phoenix' then
date_format(date(CONVERT_TZ(u.created_at,'UTC','America/Phoenix')),'%Y-%m-%d')
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date_format(date(CONVERT_TZ(u.created_at,'UTC','America/Los_Angeles') ),'%Y-%m-%d')end as sign_up_date,ar.booking_date,ar.total_spend,ar.id
from users u 
left join(
select case ar.timezone
when 'Europe/London' then
date_format(date(CONVERT_TZ(ar.created_at,'UTC','Europe/London')),'%Y-%m-%d')
when 'America/Chicago' then
date_format(date(CONVERT_TZ(ar.created_at,'UTC','America/Chicago')),'%Y-%m-%d')
when 'America/New_York' then
date_format(date(CONVERT_TZ(ar.created_at,'UTC','America/New_York')),'%Y-%m-%d')
when 'America/Phoenix' then
date_format(date(CONVERT_TZ(ar.created_at,'UTC','America/Phoenix')),'%Y-%m-%d')
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
date_format(date(CONVERT_TZ(ar.created_at,'UTC','America/Los_Angeles') ),'%Y-%m-%d')end as booking_date,ar.total_spend,ar.user_id,ar.id

from appointment_requests ar

where (ar.status='completed' or ar.status='filled') and ar.session_time>=now()-interval 100 day) ar on ar.user_id=u.id
where u.created_at>=now()-interval 100 day and kind='client'

### marketing data
select day,cost from
marketing_spendings
where day>=date_format(now()-interval 100 day,'%Y-%m-%d')
order by day

###payout
select id,appointment_request_id,payout
from appointments a

join (select appointment_id,sum(amount) as payout from earnings where created_at>=now()-interval 100 day group by appointment_id) e on e.appointment_id=a.id




