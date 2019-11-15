QUESTION_NUMBER <- 8
source('../utilities/init.R')
source('functions.R')
#############################################
# build data frame
data <- build_dataframe()
#############################################
# ANOVA test
# null hypothesis: the means of these groups don't have difference
fit <- aov(observation ~ objects, data = data)
origin_f_value <- extract_f_value(fit)
print(origin_f_value)

##################################
# perform the test
total_test_number<-10000
successful_sample_count<-0
for (i in 1:total_test_number) {
  # get ramdom sample data
  sample_data <- build_dataframe(random_sample=TRUE)
  fit <- aov(observation ~ objects, data = sample_data)
  sample_f_value <- extract_f_value(fit)
  if(sample_f_value>origin_f_value){
    successful_sample_count<-successful_sample_count+1
  }
  print(sample_f_value)
}
##################################
# analyse test result

p_value<-successful_sample_count/total_test_number

# "The p value of the randomisation test is  0"
print(paste("The p value of the randomisation test is ",p_value))

# this if statement is true in my data
if(p_value>SIGNIFICANT_LEVEL){
  print("null hypothesis holds")
}else{
  print("null hypothesis rejected. There is at least one mean from one group is different")
}

# "Original f value is 138.424207054962"
print(paste('Original f value is',origin_f_value))
##################################
finish()