# 
# select ar.user_id,
# date((convert_tz(session_time,'UTC',
#                  case timezone when 'Pacific Time (US & Canada)' 
#                  then 'America/Los_Angeles' 
#                  else timezone end))) as session_date,
# 
# us.status
# 
# 
# from appointment_requests ar
# 
# join users u
# on u.id=ar.user_id
# 
# join user_scores us
# on us.user_id=u.id
# 
# where 1=1
# and ar.status in ('completed')
# and us.user_score_type_id=4
# and ar.is_repeat=1
# and
# date((convert_tz(session_time,'UTC',
#                  case timezone when 'Pacific Time (US & Canada)' 
#                  then 'America/Los_Angeles' 
#                  else timezone end)))>='2017-03-01'
# 
# and
# date((convert_tz(session_time,'UTC',
#                  case timezone when 'Pacific Time (US & Canada)' 
#                  then 'America/Los_Angeles' 
#                  else timezone end)))<='2017-04-30'+interval 91 day
# 
# 


setwd("C:/Users/H/Desktop")
fulldata=read.csv("12332112.csv")
names(fulldata)

fulldata$session_date[1:10]
fulldata$session_date=as.Date(fulldata$session_date)
#data$timezone=as.character(data$timezone)
fulldata$status=as.character(fulldata$status)
unique(fulldata$status)

fulldata$status[which(fulldata$status=="AAA")]="AA"
#data$session_date=as.Date(data$session_date
#                          #format="%m/%d/%Y"
#                          )

#(data$session_time[1:10])






denomenator=rep(0,90)
numerator=rep(0,90)



for(hh in 1:30)
{
  temp.date=as.Date('2017-04-01')+hh-1
  
  data=fulldata[which(fulldata$session_date==temp.date),]
  
  uniq.user.id=unique(data$user_id) #on that day
  L=length(uniq.user.id) #on that day
  
  book.data=list()
  
  for(i in 1:L)
  {
    book.data[[i]]=list(user_id=uniq.user.id[i],
                        sessions=fulldata$session_date[which(fulldata$user_id==uniq.user.id[i])])
    
  }
  
  #book.data[[100]]
  
  
  
  
  #i=100
  #num_day=8
  
  #num_day=1:90
  #cond_prob=NULL
  #start=0
  
  for(num_day in 1:90)
  {
    
    for(i in 1:L)
    {
      temp.L=length(which(
        (book.data[[i]]$sessions<=temp.date+num_day)&
          (book.data[[i]]$sessions>temp.date)
      )
      )
      temp.L1=length(which(book.data[[i]]$sessions>temp.date+num_day))
      
      if(temp.L==0){denomenator[num_day]=denomenator[num_day]+1}
      if(temp.L==0&temp.L1>0){numerator[num_day]=numerator[num_day]+1}
      
    }
    #start=start+1
    #cond_prob[start]=numerator/denomenator
    
    #cond_prob
    #L
  }
}
cond_prob_overall=numerator/denomenator
plot(cond_prob_overall,type='l',
      main="The probability a repeat client \n who has not booked in X days \n would book in the following 90-X days",
      xlab="X (1<=X<=90 day)",
      ylab="Probability",
      ylim=c(0,1)
)



















crob_prob_clientrank=matrix(NA,4,90)
start=0
for( clientrank in c("AA","A","B","C"))
{
start=start+1
denomenator=rep(0,90)
numerator=rep(0,90)



for(hh in 1:30)
{
  temp.date=as.Date('2017-04-01')+hh-1
  
  data=fulldata[which(fulldata$session_date==temp.date&fulldata$status==clientrank),]
  #on that day
  uniq.user.id=unique(data$user_id) #on that day
  L=length(uniq.user.id) #on that day

  book.data=list()

for(i in 1:L)
{
  book.data[[i]]=list(user_id=uniq.user.id[i],
                    sessions=fulldata$session_date[which(fulldata$user_id==uniq.user.id[i])])
  
}

#book.data[[100]]




#i=100
#num_day=8

#num_day=1:90
#cond_prob=NULL
#start=0

for(num_day in 1:90)
{

for(i in 1:L)
{
  temp.L=length(which(
    (book.data[[i]]$sessions<=temp.date+num_day)&
    (book.data[[i]]$sessions>temp.date)
    )
  )
  temp.L1=length(which(book.data[[i]]$sessions>temp.date+num_day))
  
  if(temp.L==0){denomenator[num_day]=denomenator[num_day]+1}
  if(temp.L==0&temp.L1>0){numerator[num_day]=numerator[num_day]+1}
  
}
#start=start+1
#cond_prob[start]=numerator/denomenator

#cond_prob
#L
}
}
crob_prob_clientrank[start,]=numerator/denomenator
lines(crob_prob_clientrank[start,],type='l',
     main="The probability a repeat client \n who has not booked in X days \n would book in the following 90-X days",
     xlab="X (1<=X<=90 day)",
     ylab="Probability"
     )
}



tempcolor= c("black","red","orange","yellow","green","blue")

plot(crob_prob_overall,type='l',
      main="The probability a repeat client \n who has not booked in X days \n would book in the following 90-X days",
      xlab="X (1<=X<=90 day)",
      ylab="Probability"

for(start in 1:4)
{
lines(crob_prob_clientrank[start,],type='l',
      main="The probability a repeat client \n who has not booked in X days \n would book in the following 90-X days",
      xlab="X (1<=X<=90 day)",
      ylab="Probability"
)
}

legend(80,.99,
       legend = c("Overall","AAA","AA","A","B","C"),
       col = c("black","red","orange","yellow","green","blue"))


write.csv(data.frame(cond_prob_overall,t(crob_prob_clientrank)),file="crob_prob_clientrank1.csv")

