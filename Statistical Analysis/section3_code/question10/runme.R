QUESTION_NUMBER <- 10
source('../utilities/init.R')
source('functions.R')
#############################################
# build data frame
f_values = c()

# pick the feature from 2 to 6
for (each_feature_name in feature_names[2:6]) {
  data <- build_dataframe(each_feature_name)
  
  # perfrom anova test
  fit <- aov(observation ~ objects, data = data)
  
  # extract f value
  f_value <- extract_f_value(fit)
  f_values <- append(f_values, f_value)
  
}

names(f_values) <- feature_names[2:6]

#      height       width        span rows_with_5 cols_with_5
#     42.55325   205.16721    38.07482    41.25446    32.84354
print(f_values)

max_f_value = max(f_values)
# [1] "The maximum f values amoung these 5 features is  205.167212433079"
print(paste('The maximum f values amoung these 5 features is ', max_f_value))
#############################################
# width has the maximum f value
selected_feature <- 'width'
data <- build_dataframe(selected_feature)

"
Pairwise comparisons using t tests with pooled SD

data:  data$observation and data$objects

          envelope golfclub pencil
golfclub  1        -        -
pencil    1        1        -
wineglass <2e-16   <2e-16   <2e-16

P value adjustment method: bonferroni
"
print(pairwise.t.test(
  data$observation,
  data$objects,
  data = data,
  p.adj = 'bonferroni'
))

#############################################
finish()
