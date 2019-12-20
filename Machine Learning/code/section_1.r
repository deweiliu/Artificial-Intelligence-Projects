



# Set up ------------------------------------------------------------------
start_section1 <- function() {
  print(paste(
    strrep('-', times = 20),
    "Starting Section 1",
    strrep('-', times = 20)
  ))
  library(yaml)
  library(ggplot2)
}
print_save <- function(output_directory, file_name, data) {
  output_file <- paste(output_directory, file_name, sep = '')
  print(data)
  
  if (class(data)[1] == 'gg') {
    ggsave(output_file, dpi = 400)
  } else{
    # reference https://stackoverflow.com/tasks/30371516/how-to-save-summarylm-to-a-file/30371944
    
    sink(output_file)
    print(data)
    sink()
  }
  print(paste('Output saved at ', output_file))
  return (output_file)
}
read_configuration <- function() {
  configuration <- yaml.load_file('configuration.yml')
  return(configuration)
}

read_features <- function(feature_file) {
  read.csv(feature_file, header = TRUE, sep = '\t')
}

is_living <- function(label_name, configuration) {
  for (each in configuration$labels$living) {
    if (each == label_name) {
      return(1)
    }
  }
  return (0)
  
}
create_dir <- function(directory) {
  if (!dir.exists(directory)) {
    dir.create(directory)
  }
  return (directory)
}
start_task <- function(task_number) {
  set.seed(3060) # Ensure the result for each run is the same
  print(strrep('*', times = 50))
  print(paste("Starting Task", task_number))
  print(strrep('*', times = 50))
  
  configuration <<- read_configuration()
  feature_data <<-
    read_features(configuration$assignment2$features_file)
  output_dir <- create_dir(configuration$output_directory)
  output_dir <- create_dir(paste(output_dir, 'section1/', sep = ''))
  output_dir <<-
    create_dir(paste(output_dir, 'task', task_number, '/', sep = ''))
}
finish_task <- function(task_number, reserved_varialbes = c()) {
  print(strrep('*', times = 50))
  print(paste("Task", task_number, 'Finished'))
  print(strrep('*', times = 50))
  
  all_objects <-
    ls(envir = .GlobalEnv) #reference https://www.rdocumentation.org/packages/base/versions/3.6.1/topics/ls
  
  # do not remove functions
  all_variables <-
    setdiff(all_objects, lsf.str(envir = .GlobalEnv)) # reference https://stackoverflow.com/tasks/8305754/remove-all-variables-except-functions
  
  # Find out all varialbes to be removed
  remove_variables <-
    all_variables[!all_variables %in% reserved_varialbes]
  
  # perform removal
  rm(list = remove_variables, envir = .GlobalEnv)
}

# Section 1 ------------------------------------------------------------------
start_section1()

# Task 1 ------------------------------------------------------------------

start_task(task_number = 1)
head(feature_data)
living <-
  sapply(feature_data$label, is_living, configuration = configuration)

data <-
  cbind.data.frame(verticalness = feature_data$verticalness, living)

# summary(data)
# verticalness         living
# Min.   :0.07534   Min.   :0.0
# 1st Qu.:0.36631   1st Qu.:0.0
# Median :0.50616   Median :0.5
# Mean   :0.51907   Mean   :0.5
# 3rd Qu.:0.61048   3rd Qu.:1.0
# Max.   :1.27027   Max.   :1.0
print_save(output_dir, 'trainning data summary.txt', summary(data))


glmfit <<-
  glm(living ~ verticalness, family = 'binomial', data = data)
print_save(output_dir, 'glm_summary.txt', summary(glmfit))

beta0 <- glmfit$coefficients[1]
# beta0 = -0.0865571648593095
print(paste("beta0 =", beta0))
beta1 <- glmfit$coefficients[2]
# beta1 = 0.16676098834243
print(paste("beta1 =", beta1))

# regression line
x.range <- range(data$verticalness)
x.values <- seq(x.range[1], x.range[2], by = 0.01)
regression_line <- data.frame(verticalness = x.values)
regression_line$living.value <-
  beta0 + beta1 * regression_line$verticalness
plt <-
  ggplot(regression_line, aes(x = verticalness, y = living.value)) +
  geom_line(data = regression_line, color = 'yellow', size = 1)
print_save(output_dir, 'regression_line.jpeg', plt)

finish_task(task_number = 1,
            reserved_varialbes = c('glmfit', 'data')) # save the model for task 2

# Task 2 ------------------------------------------------------------------
start_task(task_number = 2)

# reference https://canvas.qub.ac.uk/courses/8433/files/487423?module_item_id=205269

###### Plot verticalness_distribution
plt <-
  ggplot(data, aes(x = verticalness, fill = as.factor(living))) + geom_histogram(binwidth = 0.05,
                                                                                 alpha = 0.5,
                                                                                 position = 'identity')
print_save(output_dir, 'verticalness_distribution.jpeg', plt)

###### Plut fitted curve
x.range <- range(data$verticalness)
x.values <- seq(x.range[1], x.range[2], by = 0.01)
fitted_curve <- data.frame(verticalness = x.values)
fitted_curve[['dummy.living']] <-
  predict(glmfit, fitted_curve, type = 'response')

# verticalness       dummy.living
# Min.   :0.07534   Min.   :0.4815
# 1st Qu.:0.37284   1st Qu.:0.4939
# Median :0.67034   Median :0.5063
# Mean   :0.67034   Mean   :0.5063
# 3rd Qu.:0.96784   3rd Qu.:0.5187
# Max.   :1.26534   Max.   :0.5311
summary(fitted_curve)

plt <- ggplot(data, aes(x = verticalness, y = living)) +
  geom_point(aes(colour = factor(living)),
             show.legend = T,
             position = 'dodge') +
  geom_line(
    data = fitted_curve,
    aes(x = verticalness, y = dummy.living),
    color = 'yellow',
    size = 1
  )
print_save(output_dir, 'fitted_curve.jpeg', plt)
# We gain nothing valuable from this figure


###### Predict the 160 items
# [1] "Cutoff = 0.493994840210917" with verticalness cutoff value 0.375
cutoff = predict(glmfit, data.frame(verticalness = 0.375), type = 'response')
print(paste('Cutoff =', cutoff))
data$predicted_value <- predict(glmfit, data, type = 'response')

data$living.prediction <- data$predicted_value > cutoff

# ###### correct rate
# Mode   FALSE    TRUE
# logical      48     112
summary(data$living == data$living.prediction)
correct_rate <- mean(data$living == data$living.prediction)
# "Correct Rate = 0.7"
print(paste('Correct Rate =', correct_rate))

finish_task(task_number = 2)


# Task 3 ------------------------------------------------------------------
start_task(task_number = 3)
## top2tile

build_data <- function(feature_name) {
  # constrct data frame
  living <-
    sapply(feature_data$label, is_living, configuration = configuration)
  data <-
    cbind.data.frame(top2tile = feature_data[[feature_name]], living)
  names(data) <- c(feature_name, 'living')
  return(data)
}
build_model <- function(feature_name, data) {
  # build model
  formula <- as.formula(paste('living~', feature_name))
  glmfit <<- glm(formula, family = 'binomial', data = data)
  
  print_save(output_dir,
             paste(feature_name, '_glm_summary.txt', sep = ''),
             summary(glmfit))
  
  # plot fitted curve
  x.range <- range(data[[feature_name]])
  x.values <- seq(x.range[1], x.range[2], by = 0.01)
  fitted_curve <- data.frame(x.values)
  names(fitted_curve) <- c(feature_name)
  fitted_curve[['dummy.living']] <-
    predict(glmfit, fitted_curve, type = 'response')
  
  print_save(
    output_dir,
    paste(feature_name, '_fitted_curve_summary.txt', sep = ''),
    summary(fitted_curve)
  )
  
  
  plt <- ggplot(data, aes_string(x = feature_name, y = 'living')) +
    geom_point(aes(colour = factor(living)),
               show.legend = T,
               position = 'dodge') +
    geom_line(
      data = fitted_curve,
      aes_string(x = feature_name, y = 'dummy.living'),
      color = 'yellow',
      size = 1
    )
  print_save(output_dir,
             paste(feature_name, '_fitted_curve.jpeg', sep = ''),
             plt)
  return (glmfit)
}

predict_living <-
  function(feature_name,
           feature_value_cutoff,
           data,
           glm_model) {
    cutoff_data <- data.frame(feature_value_cutoff)
    names(cutoff_data) <- c(feature_name)
    
    cutoff = predict(glm_model, cutoff_data, type = 'response')
    print(paste('Cutoff =', cutoff))
    data$predicted_value <-
      predict(glm_model, data, type = 'response')
    
    data$living.prediction <- data$predicted_value > cutoff
    
    # ###### correct rate
    # Mode   FALSE    TRUE
    # logical      48     112
    summary(data$living == data$living.prediction)
    correct_rate <- mean(data$living == data$living.prediction)
    # "Correct Rate = 0.7"
    print(paste('Correct Rate for feature', feature_name, '=', correct_rate))
  }

## peform logistic regression on feature top2tile
feature_name <- 'top2tile'
data <- build_data(feature_name)
glm_model <- build_model(feature_name, data)
feature_cutoff_value <- 60
predict_living(feature_name , feature_cutoff_value, data, glm_model)

## peform logistic regression on feature bottom2tile
feature_name <- 'bottom2tile'
data <- build_data(feature_name)
glm_model <- build_model(feature_name, data)
feature_cutoff_value <- 70
predict_living(feature_name , feature_cutoff_value, data, glm_model)

## peform logistic regression on feature horizontalness
feature_name <- 'horizontalness'
data <- build_data(feature_name)
glm_model <- build_model(feature_name, data)
feature_cutoff_value <- 0.7
predict_living(feature_name , feature_cutoff_value, data, glm_model)
