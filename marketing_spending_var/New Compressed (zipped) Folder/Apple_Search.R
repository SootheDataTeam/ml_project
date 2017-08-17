Apple_spend=read.csv("Apple search.csv")
Apple_spend$date=as.Date(as.character(Apple_spend$Period.Start),format="%m/%d/%Y")
names(Apple_spend)
Apple_spend=Apple_spend[which(Apple_spend$date<end.date),]

data$apple_search_nonbrand=Apple_spend$apple_search_nonbrand
data$apple_search_MAI=Apple_spend$apple_search_MAI
data$apple_search_BRAND=Apple_spend$apple_search_BRAND

data$apple_search_competitor=Apple_spend$apple_search_competitor
data$apple_search_search_match=Apple_spend$apple_search_search_match
data$apple_last12weeks_non_brand=Apple_spend$apple_last12weeks_non_brand


data$apple_last12weeks_competitor_new=Apple_spend$apple_last12weeks_competitor_new
data$apple_last12weeks_brand_new=Apple_spend$apple_last12weeks_brand_new
data$apple_last12weeks_search_match_new=Apple_spend$apple_last12weeks_search_match_new

