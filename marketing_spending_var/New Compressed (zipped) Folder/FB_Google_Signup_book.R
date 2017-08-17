# # 
# select
# #week_name,
# channel2,
# #sum(num_sign_up),
# #sum(num_book)
# num_sign_up,
# num_book,
# temp_date_1
# from
# 
# (select leftdf.channel2,
# 
#   num_sign_up,
#   num_book,
#   temp_date_1
#   #week(temp_date_1) as week_name
# 
#   from
# 
#   (
#     select channel2,count(*) as num_sign_up,
#     date(convert_tz(created_at,'UTC','US/Pacific'))
#     as temp_date_1
#     from
#     ( SELECT
# 
#       CASE
#       when source like '%instagram%' or '%Instagram%' then 'Instagram'
#       WHEN campaign LIKE '%ROI%' then 'Facebook'
# 
# 
# 
#       when ( source like '%facebook%' or  source ='fb') then 'Facebook'
# 
#       WHEN source like '%google%' then 'Google'
#       WHEN source like '%twitter%' then 'Twitter'
# 
# 
#       WHEN source = 'Organic' then 'Organic'
# 
#       ELSE 'Other' END as channel2,
#       u.id ,u.created_at
#       from users u
#       left join attributions a
#       on u.attribution_id = a.id
#       where u.kind='client' ) a
# 
# 
#     where date(convert_tz(created_at,'UTC','US/Pacific'))>='2017-01-25'
#     group by temp_date_1, channel2
#   ) leftdf
# 
# 
# 
# 
# 
# 
# 
#   left join
# 
# 
# 
# 
# 
#   (
# 
#     select channel2,count(*) as num_book,
#     date(convert_tz(created_at,'UTC','US/Pacific'))
#     as temp_date
#     from
#     ( SELECT
# 
#       CASE
#       when source like '%instagram%' or '%Instagram%' then 'Instagram'
#       WHEN campaign LIKE '%ROI%' then 'Facebook'
# 
# 
#       when ( source like '%facebook%' or  source ='fb') then 'Facebook'
# 
#       WHEN source like '%google%' then 'Google'
#       WHEN source like '%twitter%' then 'Twitter'
# 
#       WHEN source = 'Organic' then 'Organic'
# 
#       ELSE 'Other' END as channel2,
#       u.id ,u.created_at
#       from users u
#       left join attributions a
#       on u.attribution_id = a.id
#       where u.kind='client' ) a
# 
#     join  appointment_requests ar
#      on ar.user_id=a.id
#      where status ='completed' 
#      group by user_id) aa 
# 
#     where date(convert_tz(created_at,'UTC','US/Pacific'))>='2017-01-25'
#     group by temp_date, channel2
#   )  rightdf
# 
# 
#   on leftdf.channel2=rightdf.channel2
#   and leftdf.temp_date_1=rightdf.temp_date
# ) leftdf1





full.data=read.csv("sign up1.csv",header = T)
full.data$temp_date_1=as.character(full.data$temp_date_1)
full.data$temp_date_1=as.Date(full.data$temp_date_1,format="%Y-%m-%d")
full.data=full.data[which(full.data$temp_date_1<end.date),]
full.data=full.data[order(full.data$temp_date_1),]


full.data$num_book=as.character(full.data$num_book)
full.data$num_book[which(full.data$num_book=="NULL")]="0"
full.data$num_book=as.numeric(full.data$num_book)
full.data=full.data[which(full.data$channel2!="Twitter"),]
names(full.data)
nrow(full.data)/length(unique(full.data$channel2))

seq(1,nrow(full.data),length(unique(full.data$channel2)))
data=data.frame(V=1:(nrow(full.data)/length(unique(full.data$channel2))))
data$date=unique(full.data$temp_date_1)

data$FB_signup=full.data$num_sign_up[which(full.data$channel2=="Facebook")]
data$Inst_signup=full.data$num_sign_up[which(full.data$channel2=="Instagram")]
data$Google_signup=full.data$num_sign_up[which(full.data$channel2=="Google")]
data$Organic_signup=full.data$num_sign_up[which(full.data$channel2=="Organic")]
data$Other_signup=full.data$num_sign_up[which(full.data$channel2=="Other")]


data$FB_book=full.data$num_book[which(full.data$channel2=="Facebook")]
data$Inst_book=full.data$num_book[which(full.data$channel2=="Instagram")]
data$Google_book=full.data$num_book[which(full.data$channel2=="Google")]
data$Organic_book=full.data$num_book[which(full.data$channel2=="Organic")]
data$Other_book=full.data$num_book[which(full.data$channel2=="Other")]


data$FB_signup=data$FB_signup+data$Inst_signup
data$Organic_signup=data$Organic_signup+data$Other_signup


data$FB_book=data$FB_book+data$Inst_book
data$Organic_book=data$Organic_book+data$Other_book
