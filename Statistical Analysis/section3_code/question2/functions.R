q1_draw_histogram <- function(feature_name, set) {
  file_name <- paste(set, feature_name, sep = '_')
  file_path <- file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
  print(paste('Generating', file_path))
  jpeg(file = file_path)
  
  hist(
    feature_data[INDICES[[set]], feature_name],
    breaks = 10,
    xlab = feature_name,
    main = paste('Histogram of', feature_name, 'for', set)
  )
  dev.off()
}