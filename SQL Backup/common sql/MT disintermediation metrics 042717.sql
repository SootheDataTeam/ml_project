select a1.*,a2.total_disintermediation_by_MT
from
(select client_id,(select concat(first_name,'',last_name) as name from users where id=client_id) as client, c.name as city,therapist_id,(select concat(first_name,'',last_name) as name from users where id=therapist_id) as therapist_name,max(session_end_time) as last_session_UTC,max(disintermediation_created_at) as last_revisit_UTC, count(*) as revist_between_client_and_MT
from
(SELECT appointments.user_id as client_id, users.home_city_id as city_id, disints.*
FROM (
  SELECT therapist_id, appointment_id, therapist_region_id, id as therapist_region_activity_id, disint_created_at disintermediation_created_at, duration disintermediation_duration, datediff(disint_created_at,session_end_time) days_from_session, latitude, longitude,session_end_time
  FROM (
    SELECT therapist_id, id, appointment_id, therapist_region_id, latitude, longitude, disint_created_at, activity_type, session_time, session_end_time,
      if (therapist_region_id=@lastRegion AND @lastActivity = 'entered' AND activity_type = 'exited', timestampdiff(minute,@lastCreated,disint_created_at), 0) as duration,
      @lastCreated := disint_created_at,
      @lastRegion := therapist_region_id,
      @lastActivity := activity_type
    FROM (
      SELECT region.therapist_id, appt.id appointment_id, location.id, therapist_region_id, latitude, longitude, location.created_at disint_created_at, activity_type, session_time, session_end_time
      FROM therapist_region_activities location
      LEFT JOIN therapist_regions region ON (location.therapist_region_id=region.id)
      LEFT JOIN appointments appt ON (appt.id=region.appointment_id)
      WHERE location.hidden = false
      ORDER BY therapist_region_id, location.created_at
    ) geo,
    (SELECT @lastCreated := 0, @lastRegion := 0,@lastActivity := '') a
  ) b
  WHERE 1=1
    AND activity_type = 'exited'
    AND duration > 65 and duration < 240
    AND datediff(disint_created_at,session_time) > 3
) disints
JOIN appointments ON (disints.appointment_id=appointments.id)
JOIN users ON (disints.therapist_id=users.id)
) a
left join cities c on c.id=a.city_id 

group by client_id,therapist_id) a1
join
(select therapist_id,count(*) as total_disintermediation_by_MT
from
(SELECT appointments.user_id as client_id, users.home_city_id as city_id, disints.*
FROM (
  SELECT therapist_id, appointment_id, therapist_region_id, id as therapist_region_activity_id, disint_created_at disintermediation_created_at, duration disintermediation_duration, datediff(disint_created_at,session_end_time) days_from_session, latitude, longitude
  FROM (
    SELECT therapist_id, id, appointment_id, therapist_region_id, latitude, longitude, disint_created_at, activity_type, session_time, session_end_time,
      if (therapist_region_id=@lastRegion AND @lastActivity = 'entered' AND activity_type = 'exited', timestampdiff(minute,@lastCreated,disint_created_at), 0) as duration,
      @lastCreated := disint_created_at,
      @lastRegion := therapist_region_id,
      @lastActivity := activity_type
    FROM (
      SELECT region.therapist_id, appt.id appointment_id, location.id, therapist_region_id, latitude, longitude, location.created_at disint_created_at, activity_type, session_time, session_end_time
      FROM therapist_region_activities location
      LEFT JOIN therapist_regions region ON (location.therapist_region_id=region.id)
      LEFT JOIN appointments appt ON (appt.id=region.appointment_id)
      WHERE location.hidden = false
      ORDER BY therapist_region_id, location.created_at
    ) geo,
    (SELECT @lastCreated := 0, @lastRegion := 0,@lastActivity := '') a
  ) b
  WHERE 1=1
    AND activity_type = 'exited'
    AND duration > 65 and duration < 240
    AND datediff(disint_created_at,session_time) > 3
) disints
JOIN appointments ON (disints.appointment_id=appointments.id)
JOIN users ON (disints.therapist_id=users.id)
) a
left join cities c on c.id=a.city_id 

group by therapist_id)a2 on a1.therapist_id=a2.therapist_id



