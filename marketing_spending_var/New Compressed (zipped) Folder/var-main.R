rm(list=ls())
library(tseries)

setwd("C:/Users/H/Desktop/Monthly Report/data")


ELA=NULL
Baseline=NULL
hhh=1
for(hhh in 1:19)
{
    end.date=as.Date("2017-07-01",format="%Y-%m-%d")+hhh-1
    start.date=as.Date("2017-04-01",format="%Y-%m-%d")
    #start.date=end.date-105
 
  source("total_signup.R")
  #start.date=data$temp_date_1[1]
  
  #source("FB_Google_Signup_book.R")
  source("FB_Google_spending.R")
  #source("Apple_Search.R")
  source("Quantcast.R")
  
  names(data)
  endo.var=data[,c(#"total_signup","total_book"
                   
                   "total_signup","ft_book","rp_book"    
                   
                   #"FB_signup",  
                   #"Google_signup",
                   #"Organic_signup",
                   #"FB_book",
                   #"Google_book",
                   #"Organic_book"
                   )]
  num_signup_var=1
  
  names(data)
  exo.var=data[,c("FB_UA",
                  "FB_UART",
                  "FB_RT",
                  "QC_spend",
                  "Yelp_spend",
                  "Apple_spend",
                  "Delta_spend",
                  
                 #"apple_search_nonbrand",             
                 #"apple_search_MAI"    ,              
                 #"apple_search_BRAND"   ,             
                 #"apple_search_competitor"  ,         
                 #"apple_search_search_match"   ,      
                 #"apple_last12weeks_non_brand"   ,    
                 #"apple_last12weeks_competitor_new" , 
                 #"apple_last12weeks_brand_new" ,      
                 #"apple_last12weeks_search_match_new",
                 
                 "Google_Brand",
                 "Google_non_Brand",
                 "Google_App_Inst",
                 "Google_B2B",
                 "Podcast_spend"
                  
                  #"Google_GDN"
                  #"Google_Comp"
                  )]
  write.csv(exo.var,"exo.var.csv")
  source("endo_exo_var.R")
  summary(train.exo)
  source("VAR_estimation.R")
  source("var-prediction.R")
  source("var-elasticity.R")
  
  ELA=rbind(ELA,colSums(elasticity[(num_signup_var+1):nrow(elasticity),
  
                        2:ncol(elasticity)]))
  Baseline=rbind(Baseline,var.fit$Ph0*sd.endo.var)
  par(mfrow=c(1,1))
  
}
#write.csv(elasticity,paste(as.character(end.date),".csv",sep=""))
#output

write.csv(ELA,paste("ELA.csv",sep=""))


