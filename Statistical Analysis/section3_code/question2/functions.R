q2_get_feature_statics <- function(feature_name, set) {
  data <- feature_data[INDICES[[set]], feature_name]
  summary<-  summary(data)
  
  # get mean
  mean<-as.numeric(summary['Mean'])
  
  # get standard deviation
  stand_deviation<-sd(data)
  
  # get min
  min<-as.numeric(summary['Min.'])
  
  # get max
  max<-as.numeric(summary['Max.'])
  
  # get difference between the max and min
  difference<-max-min
  
  # get first quantile
  first_qu<-as.numeric(summary['1st Qu.'])
  
  # get Median
  median<-as.numeric(summary['Median'])
  
  # get 3rd quantile
  third_qu<-as.numeric(summary['3rd Qu.'])
  
  
  return(c(mean,stand_deviation,min,max,difference,first_qu,median,third_qu))

}