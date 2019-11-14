QUESTION_NUMBER <- 4
source('../utilities/init.R')

data <- feature_data[INDICES[['fullset']], 'nr_pix']


# calculate the mean of the data
mean = mean(data)

# calculate the sd of the data
standard_deviation = sd(data)

# For the question 4, in another word, find the cut-off value that 
# a randomly sampled image has a 95% probability of having a nr_pix value that is BELOW the cut-off value
cutoff_percentage<-1-0.05
cutoff_value<-qnorm(cutoff_percentage,mean,standard_deviation)

print(paste('The cut-off value is',cutoff_value,'that a randomly sampled image has a 5% probability of having a nr_pix value that is above the cut-off value'))

# draw figure

x <- (mean - 5 * standard_deviation):(mean + 5 * standard_deviation)
densities <- dnorm(x, mean = mean, sd = standard_deviation)

file_name <- 'nr_pix_normal_distribution_cutoff_value'
file_path <-
  file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
print(paste("Generating the figure",file_path))
jpeg(file_path)
plot(
  x,
  densities,
  type = 'l',
  col = 'red',

  xlab = 'nr_pix',
  ylab = 'density',
  main = paste('Normal distribution with cut-off value',cutoff_value)
)

abline(v=cutoff_value,col='black')
dev.off()

finish()
