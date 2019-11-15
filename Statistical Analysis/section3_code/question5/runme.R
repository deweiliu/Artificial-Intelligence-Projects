QUESTION_NUMBER <- 5
source('../utilities/init.R')
source('functions.R')
######################################a
# find out the skewness
features <- feature_names[1:14]
set <- 'fullset'
skewness <- data.frame()
for (feature_name in features) {
  data <- feature_data[INDICES[[set]], feature_name]
  skewness <- rbind(skewness, skewness(data))
  q5_draw_histogram(feature_name, set)
}

#####################
# draw sknewness table
names(skewness) <- c('skewness')
row.names(skewness) <- features

file_name <- 'Feature skewness'
file_path <-
  file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
print(paste('Generating', file_path))
jpeg(file_path,
     height = 30 * (1 + nrow(skewness)),
     width = 150 * (1 + ncol(skewness)))
grid.arrange(tableGrob(skewness))
dev.off()

######################################
# transformation

###########################3
# data transform
for (feature_name in features) {
  skewness_value <- skewness[feature_name, 'skewness']
  if (abs(skewness_value) > 1) {
    if (skewness_value > 0) {
      # right/positive skewness
      data <- feature_data[INDICES[[set]], feature_name]
      
      # Draw the histogram with data to be transformed
      q5_draw_histogram(feature_name, set,TRUE)
      
    } else{
      # left/negative skewness
      # no feature is negative skewness
      # so not implemented yet
    }
    
  }
}
