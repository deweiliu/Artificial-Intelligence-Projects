q6_draw_histogram <- function(feature_name, set) {
  file_name <- paste(set, feature_name, 'distribution', sep = '_')
  file_path <-
    file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
  print(paste('Generating', file_path))
  jpeg(file = file_path)
  
  data <- feature_data[INDICES[[set]], feature_name]
  # Draw the histogram
  hist(
    x = data,
    freq = F,
    breaks = 'FD',
    xlab = feature_name,
    main = paste('Histogram of', feature_name, 'for', set)
  )
  
  # The line of skew
  lines(x = density(data), col = "green")
  # Draw the normal distribution line
  x_coordinates <- seq(range(data)[1], range(data)[2], by = 1)
  lines(x = x_coordinates,
        y = dnorm(x_coordinates, mean(data), sd(data)),
        col = "red")
  
  dev.off()

}