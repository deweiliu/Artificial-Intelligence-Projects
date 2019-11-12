create_dir <- function(directory) {
  if (!dir.exists(directory))
    dir.create(directory)
}
finish <- function() {
  finishing_text = cat(paste(
    strrep('*', 10),
    sprintf('R script runme.R for question %d finished', QUESTION_NUMBER),
    strrep('*', 10),
    '\n',
    sep = "\n"
  ))
  finishing_text
}