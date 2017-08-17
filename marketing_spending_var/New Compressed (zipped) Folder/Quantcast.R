QC_Yelp_Delta=read.csv("Quantcast.csv")

Apple=QC_Yelp_Delta[,c("Date","Apple")]
Quantcast=QC_Yelp_Delta[,c("Date","QC")]
Yelp=QC_Yelp_Delta[,c("Date","Yelp")]
Delta=QC_Yelp_Delta[,c("Date","Delta")]
Podcast=QC_Yelp_Delta[,c("Date","Podcast")]


names(QC_Yelp_Delta)

Quantcast$Date=as.Date(as.character(Quantcast$Date),format="%m/%d/%Y")
Quantcast$spend=as.numeric(Quantcast$QC)
Quantcast1=data.frame(day=unique(full.data$temp_date_1))
                      #cost=as.numeric(Quantcast$Budget.Delivered))                         
Yelp$Date=as.Date(as.character(Yelp$Date),format="%m/%d/%Y")
Yelp$spend=as.numeric(Yelp$Yelp)
Yelp1=data.frame(day=unique(full.data$temp_date_1))
#cost=as.numeric(Quantcast$Budget.Delivered))                         

Delta$Date=as.Date(as.character(Delta$Date),format="%m/%d/%Y")
Delta$spend=as.numeric(Delta$Delta)
Delta1=data.frame(day=unique(full.data$temp_date_1))

Podcast$Date=as.Date(as.character(Podcast$Date),format="%m/%d/%Y")
Podcast$spend=as.numeric(Podcast$Podcast)
Podcast1=data.frame(day=unique(full.data$temp_date_1))
 
Apple$Date=as.Date(as.character(Apple$Date),format="%m/%d/%Y")
Apple$spend=as.numeric(Apple$Apple)
Apple1=data.frame(day=unique(full.data$temp_date_1))


Quantcast=sqldf(
  "
  select Quantcast1.*,
  ifnull(spend,0) as spend1
  from
  Quantcast1
  left join Quantcast
  on
  Quantcast.Date=Quantcast1.day
  "
)

Yelp=sqldf(
  "
  select Yelp1.*,
  ifnull(spend,0) as spend1
  from
  Yelp1
  left join Yelp
  on
  Yelp.Date=Yelp1.day
  "
)

Delta=sqldf(
  "
  select Delta1.*,
  ifnull(spend,0) as spend1
  from
  Delta1
  left join Delta
  on
  Delta.Date=Delta1.day
  "
)

Podcast=sqldf(
  "
  select Podcast1.*,
  ifnull(spend,0) as spend1
  from
  Podcast1
  left join Podcast
  on
  Podcast.Date=Podcast1.day
  "
)

Apple=sqldf(
  "
  select Apple1.*,
  ifnull(spend,0) as spend1
  from
  Apple1
  left join Apple
  on
  Apple.Date=Apple1.day
  "
)

class(Quantcast$day)

Quantcast=Quantcast[which(Quantcast$day<end.date),]
Quantcast=Quantcast[which(Quantcast$day>=start.date),]
Quantcast=Quantcast[order(Quantcast$day),]

Yelp=Yelp[which(Yelp$day<end.date),]
Yelp=Yelp[which(Yelp$day>=start.date),]
Yelp=Yelp[order(Yelp$day),]

Delta=Delta[which(Delta$day<end.date),]
Delta=Delta[which(Delta$day>=start.date),]
Delta=Delta[order(Delta$day),]

Podcast=Podcast[which(Podcast$day<end.date),]
Podcast=Podcast[which(Podcast$day>=start.date),]
Podcast=Podcast[order(Podcast$day),]



Apple=Apple[which(Apple$day<end.date),]
Apple=Apple[which(Apple$day>=start.date),]
Apple=Apple[order(Apple$day),]


data$QC_spend=as.numeric(Quantcast$spend1)
#data$QC_book=Quantcast$Conversions1

data$Yelp_spend=as.numeric(Yelp$spend1)
#data$Yelp_book=Quantcast$Conversions1
#sd(data$QC_spend)
#QC_spend=as.numeric((Quantcast$Budget.Delivered))
#sd(QC_spend)
data$Delta_spend=as.numeric(Delta$spend1)
data$Podcast_spend=as.numeric(Podcast$spend1)
data$Apple_spend=as.numeric(Apple$spend1)



#data$total_book=data$FB_book+
 # data$Google_book+
 # data$Organic_book
#data$total_signup=data$FB_signup+
  #data$Google_signup+
  #data$Organic_signup

#sum(data$total_book)/length(data$total_book)*30
