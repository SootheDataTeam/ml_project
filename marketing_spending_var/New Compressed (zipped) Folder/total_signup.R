# set @x1='2017-02-01';
# select
# #week_name,
# 
# #sum(num_sign_up),
# #sum(num_book)
# temp_date_1,
# num_sign_up,
# num_ft_book,
# num_rp_book
# 
# from
# 
# 
# (
#   select count(*) as num_sign_up,
#   date(convert_tz(created_at,'UTC','US/Pacific'))
#   as temp_date_1
#   from users u
#   #left join attributions a
#   #on u.attribution_id = a.id
#   where 1=1
#   and u.kind='client'
#   and date(convert_tz(created_at,'UTC','US/Pacific'))>=@x1
#   group by temp_date_1
# ) leftdf
# 
# 
# left join
# 
# 
# (
#   select rp.temp_date,
#   num_rp_book,
#   num_ft_book
#   from
# 
#   (select count(*) as num_rp_book,
#     date(convert_tz(created_at,'UTC','US/Pacific'))
#     as temp_date
#     from appointment_requests ar
#     where 1=1
#     and date(convert_tz(created_at,'UTC','US/Pacific'))>=@x1
#     and status='completed'
#     and is_repeat=1
#     group by temp_date) rp
# 
#   left join
# 
#   (select count(*) as num_ft_book,
#     date(convert_tz(created_at,'UTC','US/Pacific'))
#     as temp_date
#     from appointment_requests ar
#     where 1=1
#     and date(convert_tz(created_at,'UTC','US/Pacific'))>=@x1
#     and status='completed'
#     and is_repeat=0
#     group by temp_date) ft
# 
#   on rp.temp_date=ft.temp_date
# 
# 
# 
# )rightdf
# 
# on leftdf.temp_date_1=rightdf.temp_date


production=read.csv("sign up2.csv")
names(production)
production$temp_date_1=as.Date(production$temp_date_1)
production=production[order(production$temp_date_1),]
production=production[which(production$temp_date_1<end.date),]
production=production[which(production$temp_date_1>=start.date),]


data=data.frame(temp_date_1=production$temp_date_1)
data$total_signup=production$num_sign_up
data$ft_book=production$num_ft_book
data$rp_book=production$num_rp_book
  
data$total_book=data$ft_book+data$rp_book
start.date=data$temp_date_1[1]
full.data=data
