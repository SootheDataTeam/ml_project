select * from therapist_regions

select * from therapist_region_activities


#####test

select a.therapist_id,a.session_time, a.session_end_time,tra.activity_type,tra.created_at,therapist_region_id,tra.latitude as act_latitude,tra.longitude as act_longitude,tr.region_latitude as exp_latitude,tr.region_longitude as exp_longitude,platform.platform

from appointments a 
join therapist_regions tr
on a.id = tr.appointment_id
join 
therapist_region_activities tra on tr.id = tra.therapist_region_id
join (
	select user_id, platform, max(id)
	from pns_tokens
	group by user_id
	order by id desc
) as platform
on a.therapist_id = platform.user_id
where a.id=204648

order by tra.created_at



#####
select a.therapist_id,a.session_time, a.session_end_time,tra.activity_type,tra.created_at,therapist_region_id,tra.latitude as act_latitude,tra.longitude as act_longitude,tr.region_latitude as exp_latitude,tr.region_longitude as exp_longitude,platform.platform

from appointments a 
join therapist_regions tr
on a.id = tr.appointment_id
join 
therapist_region_activities tra on tr.id = tra.therapist_region_id

where a.id=206242 and timestampdiff(hour,tra.created_at,a.session_time)<=1

order by tra.created_at





select * from therapist_locations where therapist_id=244042 and created_at >'2016-09-05 1:00:00' and created_at < '2016-09-05 2:00:00'

select * from therapist_locations where therapist_id=244042
 
 
 
 ####
 
 select a.id,count(*) as cnt

from appointments a 
join therapist_regions tr
on a.id = tr.appointment_id
join 
therapist_region_activities tra on tr.id = tra.therapist_region_id
where a.status in ('compelete','reviewed') and date(a.session_time)>'2016-09-05'
group by a.id

order by cnt desc
 
 
#######

select a.therapist_id,timestampdiff(minute,min(tra.created_at),a.session_time) as interval,a.id

from appointments a 
join therapist_regions tr
on a.id = tr.appointment_id
join 
therapist_region_activities tra on tr.id = tra.therapist_region_id

where   timestampdiff(hour,tra.created_at,a.session_time)<=1 and a.status in ('complete','reviewed') and tra.activity_type='entered'
group by a.id
order by a.therapist_id,interval
 
 