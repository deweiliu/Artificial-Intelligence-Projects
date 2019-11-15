QUESTION_NUMBER <- 3
source('../utilities/init.R')
data <- feature_data[INDICES[['fullset']], 'nr_pix']


number_of_data = length(data)

# calculate the mean of the sample data
sample_mean <- mean(data)
sample_mean
# calculate the sd of the sample data
sample_standard_deviation <- sd(data)
sample_standard_deviation*sample_standard_deviation
# CLT applies
mean_of_sample_means = sample_mean
se <- sample_standard_deviation / (sqrt(number_of_data))


xaxis <-
  seq((mean_of_sample_means - 3 * se),
      (mean_of_sample_means + 3 * se),
      by = 0.01)
densities <- dnorm(xaxis, mean = mean_of_sample_means , sd = se)

# confidence = 95%
z_score=1.96
min_confience_interval <- mean_of_sample_means - z_score* se
max_confience_interval <- mean_of_sample_means + z_score * se
print(
  paste(
    'We have 95% confidence that the actual mean of the population is between',
    min_confience_interval,
    'and',
    max_confience_interval
  )
)

# draw figure normal distribution

file_name <- 'Distribution of sample means'
file_path <-
  file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
print(paste("Generating the figure", file_path))
jpeg(file_path)
plot(
  xaxis,
  densities,
  type = 'l',
  col = 'red',
  xlab = 'sample mean',
  ylab = 'density',
  main = 'Distribution of sample means'
)
abline(v=min_confience_interval)
abline(v=max_confience_interval)

dev.off()
##################
# draw figure normal distribution

xlim<-c(0,350)
ylim<-c(0,0.020)
xaxis <- xlim[1]:xlim[2]
densities <- dnorm(xaxis, mean = sample_mean, sd = sample_standard_deviation)

file_name <- 'nr_pix_normal_distribution'
file_path <-
  file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
print(paste("Generating the figure",file_path))
jpeg(file_path)
plot(
  xaxis,
  densities,
  type = 'l',
  col = 'red',
  ylim=ylim,
  xlim=xlim,
  xlab = 'nr_pix',
  ylab = 'density',
  main = 'Normal Distribution of nr_pix for fullset'
)
dev.off()
# Draw figure hostogram
# Draw the histogram and  the normal distribution line
file_name <- 'histogram of nr_pix for fullset with normal distribution line'
file_path <-
  file.path(OUTPUT_DIR, paste(file_name, FIGURE_FORMAT, sep = ''))
print(paste("Generating the figure",file_path))
jpeg(file_path)
hist(
  x = data,
  freq = F,
  ylim=ylim,
  xlim=xlim,
  breaks = 'FD',
  main = 'Histogram of nr_pix for fullset with normal distribution line',
  xlab  = 'nr_pix'
)

lines(x = xaxis,
      y = densities,
      col = "red")

dev.off()


finish()
