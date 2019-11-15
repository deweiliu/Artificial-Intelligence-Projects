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
jpeg_start<-function(file_name){
  file_path <-
    file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
  print(paste('Generating', file_path))
  jpeg(file = file_path)
}
jpeg_end<-function(){
  dev.off()
}