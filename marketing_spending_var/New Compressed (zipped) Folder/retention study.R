setwd("C:/Users/H/Desktop/Monthly Report/retention study")
fillrate=read.csv("Fill Rate- 05312017.csv")
retention=read.csv("Retention- 05312017.csv")
#retention=read.csv("Retention in 30 days  060317.csv")


NSAT=read.csv("NSAT - 05312017.csv")
engagement=read.csv("Engaged therapists- 05312017.csv")
avescore=read.csv("Avg Quality Score- 05312017.csv")
goodMT=read.csv("num_good_MT  060317.csv")

names(goodMT)
#names(fill#.rate)
names(retention)
names(NSAT)
names(engagement)
names(avescore)
#dim(fill.rate)
dim(retention)
dim(NSAT)
library(sqldf)
data=
sqldf("

select 
fillrate.date,
fillrate.city,
fillrate.fill_rate,

retention.X30_day_retention,
NSAT.nsat/100 as nps_score,

avescore.avg_quality_score,
engagement.num_MT,
engagement.is_90,
engagement.is_60,

goodMT.num_good_MT

from fillrate

join retention
on fillrate.date=retention.yr_mo
and fillrate.city=retention.city
join NSAT
on fillrate.date=NSAT.date_local
and fillrate.city=NSAT.name
join engagement
on fillrate.date=engagement.yr_m
and fillrate.city=engagement.name
join avescore
on fillrate.date=avescore.date
and fillrate.city=avescore.city
join goodMT
on fillrate.date=goodMT.date
and fillrate.city=goodMT.city

where  fillrate.date not in ('2017-05')

            "
)

Target.city=c("Los Angeles","NYC","San Francisco","All")
City=c("LA","NYC","SF","All")




class(data)
names(data)
#data=data[234:372,]










results1=data.frame(City)
results1=cbind(results1,matrix(NA,nrow(results1),20))
for(i in 1:length(Target.city))
{
  #i=1
  if(i<length(Target.city))
  {
    data1=data[which(data$city==Target.city[i]),]
    
  }
  
  if(i==length(Target.city))
  {
    data1=data
  }
  
  
  temp.form=as.formula("X30_day_retention~fill_rate")
  lm.fit=lm(temp.form,data = data1)
  
  summary.lm.fit=(summary(lm.fit))
  
  
  L=nrow((summary.lm.fit$coefficients))-1
  start=1
  for(j in 1:L)
  {
    start=start+1
    results1[i,start]=summary.lm.fit$coefficients[j+1,1]
    names(results1)[start]=rownames(summary.lm.fit$coefficients)[j+1]
    start=start+1
    results1[i,start]=summary.lm.fit$coefficients[j+1,4]
    names(results1)[start]=paste("p",j,sep="")
    
  }
}


results1[,2:start]=round(results1[,2:start],3)
results1=results1[,1:start]

results1

plot(data1$fill_rate,data1$X30_day_retention)

plot(lm.fit)





















results2=data.frame(City)
results2=cbind(results2,matrix(NA,nrow(results2),20))
for(i in 1:length(Target.city))
{
  #i=1
  if(i<length(Target.city))
  {
    data1=data[which(data$city==Target.city[i]),]
    
  }
  
  if(i==length(Target.city))
  {
    data1=data
  }
  
  
  temp.form=as.formula("X30_day_retention~nps_score")
  lm.fit=lm(temp.form,data = data1)
  
  summary.lm.fit=(summary(lm.fit))
  
  
  L=nrow((summary.lm.fit$coefficients))-1
  start=1
  for(j in 1:L)
  {
    start=start+1
    results2[i,start]=summary.lm.fit$coefficients[j+1,1]
    names(results2)[start]=rownames(summary.lm.fit$coefficients)[j+1]
    start=start+1
    results2[i,start]=summary.lm.fit$coefficients[j+1,4]
    names(results2)[start]=paste("p",j,sep="")
    
  }
}


results2[,2:start]=round(results2[,2:start],3)
results2=results2[,1:start]


#write.csv(results,file="regression1.csv")
#write.csv(results1,file="regression2.csv")











results3=data.frame(City)
results3=cbind(results3,matrix(NA,nrow(results3),20))
for(i in 1:length(Target.city))
{
  #i=1
  if(i<length(Target.city))
  {
    data1=data[which(data$city==Target.city[i]),]
    
  }
  
  if(i==length(Target.city))
  {
    data1=data
  }
  
  
  temp.form=as.formula("X30_day_retention~num_MT+num_good_MT")
  lm.fit=lm(temp.form,data = data1)
  
  summary.lm.fit=(summary(lm.fit))
  
  
  L=nrow((summary.lm.fit$coefficients))-1
  start=1
  for(j in 1:L)
  {
    start=start+1
    results3[i,start]=summary.lm.fit$coefficients[j+1,1]
    names(results3)[start]=rownames(summary.lm.fit$coefficients)[j+1]
    start=start+1
    results3[i,start]=summary.lm.fit$coefficients[j+1,4]
    names(results3)[start]=paste("p",j,sep="")
  
  }
}


results3[,2:start]=round(results3[,2:start],3)
results3=results3[,1:start]






results4=data.frame(City)
results4=cbind(results4,matrix(NA,nrow(results4),20))
for(i in 1:length(Target.city))
{
  #i=2
  if(i<length(Target.city))
  {
    data1=data[which(data$city==Target.city[i]),]
    
  }
  
  if(i==length(Target.city))
  {
    data1=data
  }
  
  
  temp.form=as.formula("X30_day_retention~num_good_MT")
  lm.fit=lm(temp.form,data = data1)
  
  summary.lm.fit=(summary(lm.fit))
  
  
  L=nrow((summary.lm.fit$coefficients))-1
  start=1
  for(j in 1:L)
  {
    start=start+1
    results4[i,start]=summary.lm.fit$coefficients[j+1,1]
    names(results4)[start]=rownames(summary.lm.fit$coefficients)[j+1]
    start=start+1
    results4[i,start]=summary.lm.fit$coefficients[j+1,4]
    names(results4)[start]=paste("p",j,sep="")
    
  }
}


results4[,2:start]=round(results4[,2:start],3)
results4=results4[,1:start]


results1
results2
results3
results4

write.csv(results1,"results1.csv")
write.csv(results2,"results2.csv")
write.csv(results3,"results3.csv")
write.csv(results4,"results4.csv")



i=1
plot(data1$avg_quality_score,main=City[i],type="l")
