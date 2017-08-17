
 
select cr.user_id,concat(u.first_name,' ',u.last_name) as name, c.city,sum(case when credit_type_id in (1,11) then amount else 0 end) as promotion,sum(case when credit_type_id in (3)	 then amount else 0 end) as referral,
sum(case when credit_type_id in (4,7,5,8,9,10)	 then amount else 0 end) as compensation_for_bad_experience,
 sum( case when credit_type_id  in (2) then amount else 0 end) as other,ar.credit_used
 from credits cr
 
 join users u on u.id=cr.user_id
 join (select user_id,sum(ifnull(credit_amount,0)) as credit_used from appointment_requests where status ='completed' group by user_id ) ar on ar.user_id=cr.user_id
 join (select user_id,city
from
(select user_id,c.name as city,count(*) cnt
from appointment_requests ar
join cities c on c.id=ar.city_id
where ar.status='completed'
group by user_id,city
order by user_id,cnt desc)a
group by user_id) c on c.user_id=cr.user_id
 
 group by user_id


select * from credits where user_id=109

select sum(amount) from credits where user_id=109 and appointment_request_id is not null
select sum(amount) from credits where user_id=201 and credit_type_id is not null

select  sum(credit_amount)  from appointment_requests where status ='completed' and user_id=109 and credit_amount >0

select * from appointment_requests where 
