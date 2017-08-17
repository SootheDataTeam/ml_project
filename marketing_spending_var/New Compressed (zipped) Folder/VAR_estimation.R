library(MTS)
source("modify MTS functions.R")
#VARXorder(endo.var, exo.var, maxp = 5, maxm = 5, output = T)
###
order.mat=matrix(NA,16,3)
order.mat[,1]=rep(1:4,each=4)
order.mat[,2]=rep(1:4,4)
###
for(r in 1:nrow(order.mat))
{
  var.fit=VARX(zt = train.endo, p =order.mat[r,1] , 
               xt = train.exo, m =order.mat[r,2], 
               include.mean = T, fixed = NULL, output = T)
  var.pred=VARXpred(m1 = var.fit,newxt = test.exo,hstep = nrow(test.endo),orig =0)
  #var.pred=VARXpred(var.fit,newxt=train.exo,hstep=nrow(train.endo),orig = 2)
  #dim(var.pred$pred.mean)
  #warnings()
  #names(var.pred)
  
  temp.sum=0
 # temp.0=matrix(NA,nrow(test.endo),nrow(train.endo))
  #temp.1=temp.0
  
#  temp=max(order.mat[r,1],
 #          order.mat[r,2])
#temp=7
 
# var.fit$data=train.endo[1:temp,]
#  var.fit$xt=train.exo[1:temp,]
#  var.pred=VARXpred(m1 = var.fit,newxt = exo.var[(temp+1):nrow(exo.var),],
#                    hstep = nrow(exo.var)-temp,
#                    orig =0)
#  var.pred$pred.mean=(var.pred$pred.mean>0)*var.pred$pred.mean
  
 # temp.weights=c(1,1,1,10,10,10)
  ###
  #for(i in (num_signup_var+1):ncol(train.endo))
  for(i in (1):ncol(train.endo))
  ###
    {
    #plot(train.endo[,i],type="l",col="red",main=names(endo.var)[i])
    
    #plot(test.endo[,i],type="l",col="red",main=names(endo.var)[i])
    #lines(var.pred$pred.mean[,i],col="blue")
    # if(diff.endo==1)
    # {
    #   temp.0[1,i]=0
    #   temp.1[1,i]=0
    #   
    #   for(j in 1:nrow(test.endo))
    #   {
    #     temp.0[j,i]=temp.0[1,i]+sum(test.endo[1:j,i])
    #     temp.1[j,i]=temp.1[1,i]+sum(var.pred$pred.mean[1:j,i])
    #   }
    #   
    #   temp.sum=temp.sum+(sum(temp.0[,i]-temp.1[,i])^2)
    #   
    # }
    
    if(diff.endo==0)
      
    { 
      
      #temp.sum=temp.sum+sum((temp.weights[i]*sd.endo.var[i]*(test.endo[,i]-var.pred$pred.mean[,i]))^2)
      #temp.sum=temp.sum+sum((sd.endo.var[i]*(test.endo[,i]-var.pred$pred.mean[,i]))^2)
      #var.pred$pred.mean[,i][which(var.pred$pred.mean[,i]<0)]=0
      
      
      temp.sum=temp.sum+sum((test.endo[,i]-var.pred$pred.mean[,i])^2)
      
      #temp.sum=temp.sum+sum(((c(train.endo[(nrow(train.endo-6)):(nrow(train.endo)),i],test.endo[,i])-var.pred$pred.mean[(length(var.pred$pred.mean)-6-7):length(var.pred$pred.mean),i]))^2)
      #temp.sum=temp.sum+sum(((test.endo[,i]-var.pred$pred.mean[,i]))^2)
      
    }
  }
  order.mat[r,3]=temp.sum
}

if(any(is.na(order.mat[,3])))
{order.mat=order.mat[-which(is.na(order.mat[,3])=="TRUE"),]}
order.mat[which.min(order.mat[,3]),]





var.fit=VARX(zt = train.endo, p =order.mat[which.min(order.mat[,3]),1] , 
             xt = train.exo, m =order.mat[which.min(order.mat[,3]),2], 
             include.mean = T, fixed = NULL, output = F)
var.pred=VARXpred(m1 = var.fit,newxt = test.exo,hstep = nrow(test.endo),orig =0)
#var.pred=VARXpred(var.fit,newxt=train.exo,hstep=nrow(train.endo),orig = 2)
#dim(var.pred$pred.mean)
#warnings()
#names(var.pred)


# 
# 
# for(i in 1:ncol(train.endo))
# {
#   #plot(train.endo[,i],type="l",col="red",main=names(endo.var)[i])
#   if(diff.endo==1)
#   {
#     temp.0[1,i]=0
#     temp.1[1,i]=0
#     
#     for(j in 1:nrow(test.endo))
#     {
#       temp.0[j,i]=sum(test.endo[1:j,i])
#       temp.1[j,i]=sum(var.pred$pred.mean[1:j,i])
#     }
#     
#     plot(temp.0[,i],type="l",col="red",main=names(endo.var)[i])
#     lines(temp.1[,i],col="blue")
#     
#     
#   }
#   if(diff.endo==0)
#   {
#   plot(test.endo[,i],type="l",col="red",main=names(endo.var)[i])
#   lines(var.pred$pred.mean[,i],col="blue")
#   }
#   #temp.sum=temp.sum+(sum(test.endo[,i]-var.pred$pred.mean[,i])^2)
#   
# }
# 
print(order.mat)
