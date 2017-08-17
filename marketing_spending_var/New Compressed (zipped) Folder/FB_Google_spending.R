# #Facebook/Google spending
# set@x1='2017-02-01';
# select type,
# cost,
# day,
# #week(day) as week_name,
# city_id
# 
# from marketing_spendings m
# join marketing_spending_campaigns mc
# on mc.id=m.marketing_spending_campaign_id
# #where channel='Facebook_Manual'
# where channel='Google'
# where channel='APPLE_SEARCH'
# #and platform not   in ('Instagram')
# #and type in ('UA','UART','RT')
# and type in ('Branded CPC','Non Branded CPC','App Installs','Competitors CPC','GDN','B2B CPC Search')
# and day>=@x1
# order by day



FB_spend=read.csv("facebook spending.csv")
Google_spend=read.csv("Google spending.csv")
Apple_spend=read.csv("Apple spending.csv")

FB_spend$day=as.character(FB_spend$day)
FB_spend$day=as.Date(FB_spend$day)
FB_spend=FB_spend[which(FB_spend$day<end.date),]
FB_spend=FB_spend[which(FB_spend$day>=start.date),]
FB_spend=FB_spend[order(FB_spend$day),]

Google_spend$day=as.character(Google_spend$day)
Google_spend$day=as.Date(Google_spend$day)
Google_spend=Google_spend[which(Google_spend$day<end.date),]
Google_spend=Google_spend[which(Google_spend$day>=start.date),]
Google_spend=Google_spend[order(Google_spend$day),]


# Apple_spend$day=as.character(Apple_spend$day)
# Apple_spend$day=as.Date(Apple_spend$day)
# Apple_spend=Apple_spend[which(Apple_spend$day<end.date),]
# Apple_spend=Apple_spend[which(Apple_spend$day>=start.date),]
# Apple_spend=Apple_spend[order(Apple_spend$day),]




# summary(FB.spend$day)
# summary(Google.spend$day)
# 
# unique(FB.spend$day)

library(sqldf)
FB_spend=sqldf(
  "select *,
  sum(cost) as global_cost
  from
  FB_spend
  group by day, type"
)


Google_spend=sqldf(
  "select *,
  sum(cost) as global_cost
  from
  Google_spend
  group by day, type"
)


# Apple_spend=sqldf(
#   "select *,
#   sum(cost) as global_cost
#   from
#   Apple_spend
#   group by day"
# )

FB_spend1=data.frame(day=rep(unique(full.data$temp_date_1),
                             each=length(unique(FB_spend$type))),
                     
                     type=rep(unique(FB_spend$type),
                              length(unique(full.data$temp_date_1))))

FB.spend=sqldf(
  "
  select FB_spend1.*,
  global_cost,
  ifnull(global_cost,0) as global_cost1
  from
  FB_spend1
  left join FB_spend
  on
  FB_spend1.day=FB_spend.day
  and
  FB_spend1.type=FB_spend.type"
)




Google_spend1=data.frame(day=rep(unique(full.data$temp_date_1),
                                 each=length(unique(Google_spend$type))),
                         
                         type=rep(unique(Google_spend$type),
                                  length(unique(full.data$temp_date_1))))

Google.spend=sqldf(
  "
  select Google_spend1.*,
  global_cost,
  ifnull(global_cost,0) as global_cost1
  from
  Google_spend1
  left join Google_spend
  on
  Google_spend1.day=Google_spend.day
  and
  Google_spend1.type=Google_spend.type"
)





# 
# Apple_spend1=data.frame(day=rep(unique(full.data$temp_date_1),
#                                  each=length(unique(Apple_spend$type))),
#                          
#                          type=rep(unique(Apple_spend$type),
#                                   length(unique(full.data$temp_date_1))))
# 
# Apple.spend=sqldf(
#   "
#   select Apple_spend1.*,
#   global_cost,
#   ifnull(global_cost,0) as global_cost1
#   from
#   Apple_spend1
#   left join Apple_spend
#   on
#   Apple_spend1.day=Apple_spend.day
#   "
# )


#nrow(FB.spend)
#summary(FB.spend$type)

#nrow(Google.spend)
#summary(Google.spend$type)

data$FB_UA=FB.spend$global_cost1[which(FB.spend$type=="UA")]
data$FB_UART=FB.spend$global_cost1[which(FB.spend$type=="UART")]
data$FB_RT=FB.spend$global_cost1[which(FB.spend$type=="RT")]

data$Google_Brand=Google.spend$global_cost1[which(Google.spend$type=="Branded CPC")]
data$Google_non_Brand=Google.spend$global_cost1[which(Google.spend$type=="Non Branded CPC")]
data$Google_App_Inst=Google.spend$global_cost1[which(Google.spend$type=="App Installs")]
data$Google_B2B=Google.spend$global_cost1[which(Google.spend$type=="B2B CPC Search")]
unique(Google.spend$type)

temp=which(unique(Google.spend$day)=="2017-04-25")
data$Google_Brand[temp]=mean(data$Google_Brand)
data$Google_non_Brand[temp]=mean(data$Google_non_Brand)
data$Google_App_Inst[temp]=mean(data$Google_App_Inst)
data$Google_B2B[temp]=mean(data$Google_B2B)


#data$Apple_spend=Apple.spend$global_cost1


