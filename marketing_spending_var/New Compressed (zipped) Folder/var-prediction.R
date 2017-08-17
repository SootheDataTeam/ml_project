
var.fit1=VARX(zt = train.endo, 
             p =order.mat[which.min(order.mat[,3]),1], 
            # p=6,
             xt = train.exo, 
             #m=6,
             m=order.mat[which.min(order.mat[,3]),2], 
             include.mean = T, fixed = NULL, output = T)

var.fit=refVARX(m1 = var.fit1,thres = 0)


#var.pred=VARXpred(m1 = var.fit,newxt = test.exo,hstep = nrow(test.endo),orig =0)
#var.pred=VARXpred(var.fit,newxt=train.exo,hstep=nrow(train.endo),orig = 2)
#dim(var.pred$pred.mean)
#warnings()
names(var.pred)
order.mat[which.min(order.mat[,3]),]
# temp.sum=0
# for(i in 1:ncol(train.endo))
# {
#   #plot(train.endo[,i],type="l",col="red",main=names(endo.var)[i])
#   
#   plot(test.endo[,i],type="l",col="red",main=names(endo.var)[i])
#   lines(var.pred$pred.mean[,i],col="blue")
#   
#   #temp.sum=temp.sum+(sum(test.endo[,i]-var.pred$pred.mean[,i])^2)
#   
# }

#names(var.fit)


#(var.fit$data)

temp=max(order.mat[which.min(order.mat[,3]),1],
         order.mat[which.min(order.mat[,3]),2]+1)
temp=7

var.fit$data=train.endo[1:temp,]
var.fit$xt=train.exo[1:temp,]
var.pred=VARXpred(m1 = var.fit,newxt = exo.var[(temp+1):nrow(exo.var),],
                  hstep = nrow(exo.var)-temp,
                  orig =0)
var.pred$pred.mean=(var.pred$pred.mean>0)*var.pred$pred.mean
temp.0=matrix(NA,nrow(var.pred$pred.mean),nrow(train.endo))
temp.1=temp.0

for(i in 1:ncol(train.endo))
{
  #plot(train.endo[,i],type="l",col="red",main=names(endo.var)[i])
  # if(diff.endo==1)
  # {
  #   temp.0[1,i]=0
  #   temp.1[1,i]=0
  #   
  #   for(j in 1:nrow(var.pred$pred.mean))
  #   {
  #     temp.0[j,i]=sum(endo.var[(temp+1):nrow(endo.var),i][1:j])
  #     temp.1[j,i]=sum(var.pred$pred.mean[1:j,i])
  #   }
  #   
  #   plot(temp.0[,i],type="l",col="red",main=names(endo.var)[i])
  #   lines(temp.1[,i],col="blue")
  #   lines(c(length((temp+1):nrow(endo.var))-n.test,length((temp+1):nrow(endo.var))-n.test),
  #         c(-1000,1000))
  #   
  # }
  
  
  if(diff.endo==0)
  {
  plot(endo.var[(temp+1):nrow(endo.var),i],type="l",col="red",main=names(endo.var)[i])
  lines(var.pred$pred.mean[,i],col="blue")
  lines(c(length((temp+1):nrow(endo.var))-n.test,length((temp+1):nrow(endo.var))-n.test),
        c(-1000,1000))
  }
  #temp.sum=temp.sum+(sum(test.endo[,i]-var.pred$pred.mean[,i])^2)
  
}

for(i in 1:ncol(endo.var))
{
  print(names(endo.var)[i])
  
  temp.0=(sum(endo.var[(nrow(endo.var)-n.test+1):nrow(endo.var),i]))
  #print(temp.0)
  temp.1=(sum(var.pred$pred.mean[(length(var.pred$pred.mean[,i])-n.test+1):length(var.pred$pred.mean[,i]),i]))
  #print(temp.1)
  print(abs(temp.1-temp.0)/temp.0*100)
  
  }
# 
# names(endo.var)
# names(exo.var)
# endo.var[(temp+1):nrow(endo.var),5]
#hist(endo.var$FB_book)
#train.exo
#test.endo
