QUESTION_NUMBER <- 7
source('../utilities/init.R')
source('functions.R')

#############################################
# build data frame
feature_name = 'nr_pix'
objects <-
  c(rep('wineglass', 20),
    rep('golfclub', 20),
    rep('pencil', 20),
    rep('envelope', 20))
objects
observation <- c(feature_data[INDICES[['wineglass']], feature_name],
                 feature_data[INDICES[['golfclub']], feature_name],
                 feature_data[INDICES[['pencil']], feature_name],
                 feature_data[INDICES[['envelope']], feature_name])
data <- data.frame(observation, objects)
data
#############################################
# visualise the data

# dotplot
# reference: http://www.sthda.com/english/wiki/ggplot2-dot-plot-quick-start-guide-r-software-and-data-visualization
jpeg_start('dotplot_nr_pix_observations')
ggplot(data, aes(x = objects, y = observation)) +
  geom_dotplot(binaxis = 'y', stackdir = 'center')
jpeg_end()

# boxplot
# reference: http://www.sthda.com/english/wiki/ggplot2-box-plot-quick-start-guide-r-software-and-data-visualization
jpeg_start('boxplot_nr_pix_observations')
ggplot(data, aes(x = objects, y = observation)) +
  geom_boxplot()+
  geom_dotplot(binaxis = 'y', stackdir = 'center')
jpeg_end()

# histogram
# reference: http://www.sthda.com/english/wiki/ggplot2-histogram-plot-quick-start-guide-r-software-and-data-visualization
# http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/
file_name <- ('histogram_nr_pix_observations')
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
jpeg_start('density_nr_pix_observations')
ggplot(data, aes(x = observation, fill = objects, color = objects)) +
  geom_density(alpha = .5)
jpeg_end()

##################################
# ANOVA test
fit<-aov(observation~objects,data=data)
summary(fit)

finish()
