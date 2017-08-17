select a.id,a.email,a.Used,a.Applied,unfilled,ifnull(a1.completed,0) as completed
from
(SELECT
        users.id,
        users.email,
        CONVERT_TZ(appointment_requests.created_at,'UTC','US/Pacific') as request_date,
        discounts.code,
        sum(CASE WHEN appointment_requests.status = 'completed' then 1 else 0 end) as Used ,
       count(*) as Applied,sum(case when (appointment_requests.status='cancelled' and is_unfilled =1 ) then 1 else 0 end) as unfilled
        
    
    FROM users
    JOIN appointment_requests
    ON users.id = appointment_requests.user_id
     JOIN user_discounts
    ON appointment_requests.user_discount_id = user_discounts.id
     JOIN discounts
    ON user_discounts.discount_id = discounts.id
    WHERE (discounts.code = "cozy10")
    AND CONVERT_TZ(appointment_requests.created_at,'UTC','US/Pacific') BETWEEN '2016-12-02 18:00:00' AND '2016-12-05 11:59:00'
    group by users.id)a
    
    
    left join 
    
    (SELECT
        user_id,count(*) as completed
        
    from
		appointment_requests
 where CONVERT_TZ(appointment_requests.created_at,'UTC','US/Pacific') BETWEEN '2016-12-02 6:00:00' AND '2016-12-05 11:59:00' and status='completed'
  group by user_id) a1 on a. id=a1.user_id
    
    