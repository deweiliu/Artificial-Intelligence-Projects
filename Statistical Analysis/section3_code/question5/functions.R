q5_draw_histogram <-
  function(feature_name, set, is_data_transformed = FALSE) {
    data <- feature_data[INDICES[[set]], feature_name]
    if (is_data_transformed) {
      data <- log1p(data)
      new_skewness<-skewness(data)
    }
    
    if (is_data_transformed) {
      file_name <-
        paste('transformed', set, feature_name, 'distribution', sep = '_')
    } else{
      file_name <- paste(set, feature_name, 'distribution', sep = '_')
    }
    file_path <-
      file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
    print(paste('Generating', file_path))
    jpeg(file = file_path)
    

    # Draw the histogram
    if(is_data_transformed){
      main_text=paste('Histogram of', feature_name, 'for', set, 'new skewness',new_skewness)
    }else{
      main_text=paste('Histogram of', feature_name, 'for', set)
    }
    hist(
      x = data,
      freq = F,
      breaks = 'FD',
      xlab = feature_name,
      main = main_text
    )
    
    # The line of skew
    lines(x = density(data), col = "green")
    # Draw the normal distribution line
    x_coordinates <- seq(range(data)[1], range(data)[2], by = 0.05)
    densities <- dnorm(x_coordinates, mean(data), sd(data))
    lines(x = x_coordinates,
          y = densities,
          col = "red")
    
    dev.off()
    
    
    
  }
