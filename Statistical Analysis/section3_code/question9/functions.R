

build_dataframe <- function(feature_name) {
  objects <-
    c(rep('living', 80),
      rep('nonliving', 80))
  objects
  
  
  observation <-
    c(feature_data[INDICES[['living']], feature_name],
      feature_data[INDICES[['nonliving']], feature_name])
  
  data <- data.frame(observation, objects)
  return(data)
}