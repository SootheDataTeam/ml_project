#client_at_risk
select a.user_id,
	   recency as score,
	   case when recency>2*freq then 'At Risk' else 'Not At Risk' end as status
 from(
	SELECT user_id,
		   DATEDIFF(current_date(),min(DATE(ar.created_at))) tenure,
		   DATEDIFF(current_date(),max(DATE(ar.created_at))) recency,
		   DATEDIFF(current_date(),min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as freq
		 FROM appointment_requests ar
		 WHERE status='completed' OR (status='cancelled' AND is_unfilled=1)
		 group by user_id) a


 
