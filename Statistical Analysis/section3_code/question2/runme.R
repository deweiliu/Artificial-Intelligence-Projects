QUESTION_NUMBER <- 1
source('../utilities/init.R')
source('functions.R')
statics_names <- c('mean','standard deviation','minimum','maximum','range','1st quantile','median','3rd quantile')
sets <- c('living', 'nonliving', 'fullset')
for (set in sets) {
  statics_data<-data.frame(stringsAsFactors = FALSE)
  for (feature_name in feature_names) {
    current_statics_data<-q2_get_feature_statics(feature_name,set)
    statics_data<-rbind(statics_data,current_statics_data)
  }
  names(statics_data)<-statics_names
  row.names(statics_data)<-feature_names
  
  # convert data frome to jpeg file
  file_name <- paste(set, 'statics', sep = '_')
  file_path <-    file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
  print(paste('Generating', file_path))
  jpeg(file_path,height=30*nrow(statics_data),width=150*ncol(statics_data))
  grid.arrange(tableGrob(statics_data))
  dev.off()
  
}
finish()
