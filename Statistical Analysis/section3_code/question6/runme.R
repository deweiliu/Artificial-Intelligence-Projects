QUESTION_NUMBER <- 6
source('../utilities/init.R')
source('functions.R')
data_height<-feature_data[INDICES[['fullset']],'height']
data_span<-feature_data[INDICES[['fullset']],'span']

##############################
# scatterplot
file_name <- 'catterplot_height-span'
file_path <-
  file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
print(paste('Generating', file_path))
jpeg(file = file_path)
attach(mtcars)
plot(data_height, data_span, main="Scatterplot height~span",
     xlab="height ", ylab=" span")
# Reference https://www.statmethods.net/graphs/scatterplot.html
# Add fit lines

abline(lm(data_span~data_height), col="red") # regression line (y~x)
lines(lowess(data_height,data_span), col="blue") # lowess line (x,y)
dev.off()
###########################################
# test if the feature is normally distributed
q6_draw_histogram('height','fullset')
# test if the feature is normally distributed
q6_draw_histogram('span','fullset')

###########################################
# correlation test
print(cor.test(data_height,data_span))
###########################################
finish()
