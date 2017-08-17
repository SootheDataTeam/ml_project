
var.fit1=VARX(zt = endo.var, 
              p =order.mat[which.min(order.mat[,3]),1], 
              xt = exo.var, 
           
              m =order.mat[which.min(order.mat[,3]),2], 
              include.mean = T, fixed = NULL, output = T)

#var.fit=refVARX(m1 = var.fit1,thres = 0)
var.fit1$coef

var.fit=var.fit1
print(var.fit$Ph0*sd.endo.var)
#test.exo=test.exo[1:7,]
###
num_irf=21
###
elasticity=matrix(NA,num_endo,ncol(exo.var))
par(mfrow=c(3,3))
for(i in 1:nrow(elasticity))
{
  for(j in 1:ncol(elasticity))
  {
    #test.exo=matrix(0*rnorm(prod(dim(test.exo))),nrow(test.exo),ncol(test.exo))
    temp.mat=matrix(0,num_irf,ncol(test.exo))
    temp.mat1=temp.mat
    temp.mat1[1,j]=temp.mat[1,j]+1
    var.pred=VARXpred(var.fit,
                      newxt=temp.mat,
                      hstep=nrow(temp.mat),
                      orig = 0)
    
    #plot(var.pred$pred.mean[,1],type="l",ylim=c(0,2))
    temp.pred=var.pred$pred.mean[,i]
    
    var.pred=VARXpred(var.fit,
                      newxt=temp.mat1,
                      hstep=nrow(temp.mat1),
                      orig = 0)
    
    #plot(var.pred$pred.mean[,1],type="l",ylim=c(0,2))
    temp.pred.1=var.pred$pred.mean[,i]
    
    elasticity[i,j]=sum(temp.pred.1-temp.pred)
   
   # plot((temp.pred.1-temp.pred)*sd.endo.var[i]/sd.exo.var[j]  ,xlab=names(exo.var)[j],ylab=names(endo.var)[i],type="l")
   # lines(c(0,100),c(0,0),col="red")
    
    
    elasticity[i,j]=elasticity[i,j]*sd.endo.var[i]/sd.exo.var[j]  
    #elasticity[i,j]=1/elasticity[i,j]
  }
}

par(mfrow=c(1,1))
elasticity=as.data.frame(elasticity)
names(elasticity)=names(exo.var)[1:num_exo]
endo_names=names(endo.var)
elasticity=data.frame(endo_names,elasticity)
# View(elasticity)
# for(i in 1:7)
# {
#   print(sd(exo.var[,i]))
# }




library(lpSolve)
library(Matrix)
# signup.to.book=sum(endo.var[,1]*sd.endo.var[1]+
#                    endo.var[,2]*sd.endo.var[2]+
#                    endo.var[,3]*sd.endo.var[3])/
#   sum(endo.var[,4]*sd.endo.var[4]+
#         endo.var[,5]*sd.endo.var[5]+
#         endo.var[,6]*sd.endo.var[6])
# 
signup.book.weights=1/c(rep(1,num_endo-num_signup_var))

obj.fun=(signup.book.weights*(as.matrix(elasticity[(num_signup_var+1):num_endo,2:ncol(elasticity)])))
#obj.fun/as.matrix(elasticity[4:num_endo,2:ncol(elasticity)])
obj.fun=colSums(matrix(obj.fun[,1:num_exo],nrow=num_endo-num_signup_var))


constr=rbind(diag(num_exo),diag(num_exo))
#constr=rbind(rep(1,num_exo),constr)
constr.dir <- c(rep("<=",num_exo),rep(">=",num_exo))


box.width=.15
upper.bound=exo.var[nrow(exo.var),1:num_exo]*(1+box.width)
lower.bound=exo.var[nrow(exo.var),1:num_exo]*(1-box.width)


upper.bound=as.numeric(upper.bound*sd.exo.var[1:num_exo])
lower.bound=as.numeric(lower.bound*sd.exo.var[1:num_exo])



data$day_of_week=weekdays(data$temp_date_1,abbreviate = T)
#weekend.spend=mean(total_spend[which(data$day_of_week=="Sat"|data$day_of_week=="Sun")])
#weekday.spend=mean(total_spend[-which(data$day_of_week=="Sat"|data$day_of_week=="Sun")])

if(weekdays(end.date,abbreviate = T)=="Sat")
{
  upper.bound=upper.bound*1.4
  lower.bound=lower.bound*1.4
  
  }

if(weekdays(end.date,abbreviate = T)=="Mon")
{
  upper.bound=upper.bound/1.4
  lower.bound=lower.bound/1.4
  
}




#summary(exo.var[,1:num_exo])




upper.bound=as.vector(ifelse(upper.bound>1,
       upper.bound,
       .5*colMeans(data.matrix(exo.var[,1:num_exo])%*%diag(sd.exo.var[1:num_exo]))
   ))
upper.bound[4:num_exo]=0.000000000000001
lower.bound[4:num_exo]=0


rhs <- c(#1000,#total spend
         
        upper.bound,
        lower.bound
         
)

#solving model
prod.sol <- lp ("max", obj.fun , constr , constr.dir, rhs ,
                compute.sens = F )
print(obj.fun)
print(data.frame(channel=names(exo.var)[1:num_exo],spending=prod.sol$solution))
#names(exo.var)
#obj.fun
View(elasticity)
#elasticity


#prod.sol$solution[5:num_exo]=NA


output=data.frame(channel=names(exo.var)[1:num_exo],
           elasticity=obj.fun,
          spending=prod.sol$solution)
