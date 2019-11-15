QUESTION_NUMBER <- 9
source('../utilities/init.R')
source('functions.R')
#############################################
# build data frame

selected_feature_names<-c()
selected_feature<-c()

# Use t test to examine every feature between living and non-living
for (feature_name in feature_names) {
  living<-feature_data[INDICES[['living']], feature_name]
  nonliving<-feature_data[INDICES[['nonliving']], feature_name]
  result<-t.test(living,nonliving)
  p_value<-result[['p.value']]
  if(p_value<SIGNIFICANT_LEVEL){
    selected_feature<-append(selected_feature,p_value)
    selected_feature_names<-append(selected_feature_names,feature_name)
  }
}
print('Below are the features with its P-values lower than the SIGNIFICANT LEVEL of 0.05')
names(selected_feature)<-selected_feature_names
print(selected_feature)

print('The feature with lowest P-value is')
print(min(selected_feature))
#############################################
data<-build_dataframe('top2tile')
data


#############################################
# visualise the data

# dotplot
# reference: http://www.sthda.com/english/wiki/ggplot2-dot-plot-quick-start-guide-r-software-and-data-visualization
jpeg_start('dotplot_top2tile_observations')
ggplot(data, aes(x = objects, y = observation)) +
  geom_dotplot(binaxis = 'y', stackdir = 'center')
jpeg_end()

# boxplot
# reference: http://www.sthda.com/english/wiki/ggplot2-box-plot-quick-start-guide-r-software-and-data-visualization
jpeg_start('boxplot_top2tile_observations')
ggplot(data, aes(x = objects, y = observation)) +
  geom_boxplot()+
  geom_dotplot(binaxis = 'y', stackdir = 'center')
jpeg_end()

# histogram
# reference: http://www.sthda.com/english/wiki/ggplot2-histogram-plot-quick-start-guide-r-software-and-data-visualization
# http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/
file_name <- ('histogram_top2tile_observations')
file_path <-
  file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
print(paste('Generating', file_path))
jpeg(file = file_path)
ggplot(data, aes(x = observation, fill = objects)) +
  geom_histogram(binwidth = 10,
                 alpha = .5,
                 position = "identity")
dev.off()

# density
# http://www.sthda.com/english/wiki/ggplot2-density-plot-quick-start-guide-r-software-and-data-visualization
jpeg_start('density_top2tile_observations')
ggplot(data, aes(x = observation, fill = objects, color = objects)) +
  geom_density(alpha = .5)
jpeg_end()

##################################
#############################################

finish()
