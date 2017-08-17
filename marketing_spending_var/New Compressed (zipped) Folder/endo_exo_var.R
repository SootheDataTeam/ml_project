
###
n.test=7

num_exo=ncol(exo.var)
###
###
total_spend=rowSums(exo.var[,1:4])
###




if(start.date<=as.Date("2017-02-17"))
{
  exo.var$social_influencer=rep(0,nrow(exo.var))
  exo.var$social_influencer[which(unique(full.data$temp_date_1)=="2017-02-17")]=1
}


if(start.date<=as.Date("2017-05-13"))
{
  exo.var$M.day=rep(0,nrow(exo.var))
  exo.var$M.day[which(unique(full.data$temp_date_1)=="2017-05-13")]=1
}

#exo.var$special_4=rep(0,nrow(exo.var))
#exo.var$special_4[which(unique(full.data$temp_date_1)=="2017-05-14")]=1


num_endo=ncol(endo.var)
num_special=ncol(exo.var)-num_exo

library(vars)

diff.endo=0
if(diff.endo==1)
{
  endo.var.2=endo.var
  endo.var.1=endo.var[1:(nrow(endo.var)-1),]
  for(i in 1:ncol(endo.var))
  {
    #endo.var[,i]=(endo.var[,i]/sd(endo.var[,i]))
    endo.var.1[,i]=diff(endo.var[,i])
    endo.var.1[,i]=endo.var.1[,i]/sd(endo.var.1[,i])
  }
  endo.var=endo.var.1
  exo.var=exo.var[2:nrow(exo.var),]
}

if(diff.endo==0)
{
  
  sd.endo.var=NULL
  for(i in 1:ncol(endo.var))
  {
    sd.endo.var[i]=sd(endo.var[,i])
    endo.var[,i]=(endo.var[,i]/sd(endo.var[,i]))
    #endo.var[,i]=diff(endo.var[,i]/sd(endo.var[,i]))
  }
}
sd.exo.var=NULL
for(i in 1:(ncol(exo.var)-num_special))
{
  sd.exo.var[i]=sd(exo.var[,i])
  exo.var[,i]=exo.var[,i]/sd(exo.var[,i])
}
sd.exo.var[(ncol(exo.var)-num_special+1):ncol(exo.var)]=1


for(i in 1:ncol(endo.var))
{
  #print(sd(endo.var[,i]))
  #plot(endo.var[,i],type="l")
}







n.train=nrow(endo.var)-n.test

train.endo=endo.var[1:(n.train),]
test.endo=endo.var[(n.train+1):(nrow(endo.var)),]

train.exo=exo.var[1:n.train,]
test.exo=exo.var[(n.train+1):nrow(exo.var),]

# 
# data$Google_GDN=rep(0,nrow(data))
# data$Google_GDN[1:24]=Google.spend$sum.cost.[which(Google.spend$type=="GDN")]
# data$Google_Comp=rep(0,nrow(data))
# data$Google_Comp[1:24]=Google.spend$sum.cost.[which(Google.spend$type=="Competitors CPC")]
# data$Google_GDN=data$Google_GDN+data$Google_Comp

#which.max(data$Organic_signup)

#data=data[1:90,]
# plot(data$FB_signup,type="l")
# plot(data$Google_signup,type="l")
# #plot(data$Inst_signup,type="l")
# 
# plot(data$Organic_signup,type="l")
# #plot(data$Other_signup,type="l")
# plot(data$FB_book,type="l")
# plot(data$Google_book,type="l")
# #plot(data$Inst_signup,type="l")
# 
# plot(data$Organic_book,type="l")
# 
# 
# plot(data$Google_Brand,type="l")
# plot(data$Google_Brand,type="l")
# 
# 
# plot(data$FB_RT,type="l")
# plot(data$FB_UA,type="l")
# plot(data$FB_UART,type="l")
# plot(diff(data$FB_signup),type="l")
# plot(log(data$Google_signup),type="l")
# plot(data$Inst_signup,type="l")
# 

# adf.test(x = (data$FB_signup),alternative = "s",k = 3)
# adf.test(x = (data$Google_signup),alternative = "s",k=3)
# adf.test(x = (data$Organic_signup),alternative = "s",k = 3)
# 
# kpss.test(x=(data$FB_RT), null = c("L"), lshort = F)
# kpss.test(x=(data$Google_signup), null 
#           = c("L"), lshort = F)
# kpss.test(x=(data$Organic_signup), null = c("L"), lshort = F)
# 
# 
# pp.test(x=(data$FB_signup), alternative = c("stationary"),type = c("Z(alpha)"), lshort = F)
# pp.test(x=(data$Google_signup), alternative = c("stationary"),type = c("Z(alpha)"), lshort = F)
# pp.test(x=(data$Organic_signup), alternative = c("stationary"),type = c("Z(alpha)"), lshort = F)

#plot(diff(log(data$Organic_signup)),type="l")

