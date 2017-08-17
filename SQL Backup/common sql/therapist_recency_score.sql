#therapist_recency_score
	select id as user_id, therapist_recency_score as score
       from
       (select r.id,
          case when monthly_sp>=5.5 then 5
            when monthly_sp<5.5 and monthly_sp>=4 then 4
            when monthly_sp<4 and monthly_sp>=2 then 3
            when monthly_sp<2 and monthly_sp>=0.5 then 2
            when monthly_sp<0.5 and monthly_sp>0 then 1
            else 0 end as special_request_score,
          case when productivity>=20 then 5
            when productivity<20 and productivity>15 then 4
            when productivity<15 and productivity>10 then 3
            when productivity<10 and productivity>6 then 3
            when productivity<6 and productivity>2 then 1
            else 0 end as productivity_score,
          case when recency<=0 then 5
            when recency<=1 and recency>0 then 3
            when recency<=2 and recency>1 then 1
            else 0 end as therapist_recency_score,client_rating,
          case when working_point>=3.5 then 5
            when working_point<3.5 and working_point>=3.1 then 4
            when working_point<3.1 and working_point>=3.0 then 3
            when working_point<3.0 and working_point>=2.8 then 2
            when working_point<2.8 and working_point>=2.1 then 1
            else 0 end as effort_rate_score
        from (
          select u.id,
            round(ifnull(ifnull(cnt,0)/a.active_month,0),1) as monthly_sp,
            round(ifnull(f.completed_sessions/active_month,0),0) as productivity,
            recency,
            round(ifnull(client_rating,0),1) as client_rating,
            working_point
          from users u
          left join (
            select therapist_id,count(*) as cnt
            from therapist_preferences sp
            group by therapist_id) sp on sp.therapist_id=u.id
          join (
            select therapist_id,
              count(distinct(date_format(session_time,'%Y-%m'))) as active_month
            from appointments
            where status in ('complete', 'reviewed')
            group by therapist_id
          ) a on a.therapist_id=u.id
          join (
            select f.therapist_id,
              (sum(case when session_hour_local>=19 then 2 else 1 end) + sum(case when dayofweek_local not in ('7','1') then 1 else 2 end  ))/count(*) as working_point,
              count(*) as completed_sessions,timestampdiff(month,max(session_time),now()) as recency
          from (
            select a.therapist_id,ar.session_time,
              hour(CONVERT_TZ(ar.session_time,'UTC',timezone) ) as session_hour_local,
              DAYOFWEEK(CONVERT_TZ(ar.session_time,'UTC',timezone) ) as dayofweek_local
            from appointments a
            join appointment_requests ar on ar.id=a.appointment_request_id
            where (a.status='complete' or a.status='reviewed')
          ) f
          group by f.therapist_id) f on f.therapist_id=u.id
          where u.kind='therapist' and id <>14655 and suspended<>1
        ) r
	)a