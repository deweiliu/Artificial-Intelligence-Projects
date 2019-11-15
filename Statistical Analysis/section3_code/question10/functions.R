


build_dataframe <- function(feature_name) {
  objects <-
    c(rep('wineglass', 20),
      rep('golfclub', 20),
      rep('pencil', 20),
      rep('envelope', 20))
  objects
  
  
  observation <-
    c(feature_data[INDICES[['wineglass']], feature_name],
      feature_data[INDICES[['golfclub']], feature_name],
      feature_data[INDICES[['pencil']], feature_name],
      feature_data[INDICES[['envelope']], feature_name])
  
  data <- data.frame(observation, objects)
  return(data)
}
extract_f_value <- function(aov) {
  return(summary(aov)[[1]][["F value"]][1])
}