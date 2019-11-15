q2_get_feature_statics <- function(feature_name, set) {
  data <- feature_data[INDICES[[set]], feature_name]
  summary <-  summary(data)
  
  # get mean
  mean <- as.numeric(summary['Mean'])
  
  # get standard deviation
  stand_deviation <- sd(data)
  
  # get min
  min <- as.numeric(summary['Min.'])
  
  # get max
  max <- as.numeric(summary['Max.'])
  
  # get difference between the max and min
  difference <- max - min
  
  # get first quantile
  first_qu <- as.numeric(summary['1st Qu.'])
  
  # get Median
  median <- as.numeric(summary['Median'])
  
  # get 3rd quantile
  third_qu <- as.numeric(summary['3rd Qu.'])
  
  
  return(c(
    mean,
    stand_deviation,
    min,
    max,
    difference,
    first_qu,
    median,
    third_qu
  ))
  
}

compare_feature_in_sets <- function(feature_name, set1, set2) {
  data1 <- feature_data[INDICES[[set1]], feature_name]
  plot1 <- hist(data1)
  data2 <- feature_data[INDICES[[set2]], feature_name]
  plot2 <- hist(data2)
  max <- max(max(data1), max(data2))
  file_name <-
    paste(feature_name, 'compared in', set1, set2, sep = '_')
  file_path <-
    file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
  print(paste('Generating', file_path))
  jpeg(file_path)
  
  plot(
    plot1,
    col = rgb(0, 1, 0, 1 / 4),
    xlim = c(0, max),
    xlab = feature_name,
    main = paste('Histogram of ', feature_name, 'for', set1, 'and', set2)
  ) # green
  plot(plot2, col = rgb(1, 0, 0, 1 / 4), xlim = c(0, max),add = T) # red
  
  legend(x = "topright", legend = c(paste("Green =", set1), paste("Red = ", set2))) # add text
  dev.off()
}
