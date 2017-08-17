### Suspend MTs who is inactive for 12 month
select id,concat(first_name,' ',last_name) as name, lt_app as last_appointment_date,created_at as sign_up_time
from
(select u.id,first_name,last_name,lt_app,created_at from users u
left join ( select therapist_id,max(session_time) as lt_app from appointments where status in ('complete','reviewed') group by therapist_id  ) a on a.therapist_id=u.id


where u.kind='therapist' and suspended <>1)a

where  ((lt_app is not null and timestampdiff(year,lt_app,now())>=1) or (lt_app is null and timestampdiff(year,created_at,now())>=1)) and id not in (select distinct(therapist_id) from b2b_sessions where therapist_id is not null)
