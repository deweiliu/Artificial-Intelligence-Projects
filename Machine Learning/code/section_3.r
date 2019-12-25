# Dewei Liu 40216004


# Set up ------------------------------------------------------------------
start_section3 <- function() {
  print(paste(
    strrep('-', times = 20),
    "Starting Section 3",
    strrep('-', times = 20)
  ))
  library(yaml)
  library(caret)
  library(ggplot2)
  library(class)
  library(rpart)
  library(randomForest)
  library(ipred)
  library(vip)
  library(e1071)
  
}
finish_section3 <- function() {
  print(paste(
    strrep('-', times = 20),
    "Section 3 Finished",
    strrep('-', times = 20)
  ))
  rm(list = ls(envir = .GlobalEnv), envir = .GlobalEnv)
}
print_save <-
  function(output_directory,
           file_name,
           data,
           append = FALSE,
           use_cat = TRUE) {
    output_file <- paste(output_directory, file_name, sep = '')
    print(data)
    
    if (class(data)[1] == 'gg') {
      ggsave(output_file, dpi = 400)
    } else{
      # reference https://stackoverflow.com/tasks/30371516/how-to-save-summarylm-to-a-file/30371944
      
      sink(output_file, append = append)
      if (class(data)[1] == 'data.frame') {
        # print dataframe without row indices
        print(data, row.names = FALSE)
      }
      else  if (class(data)[1] == 'table') {
        print(data)
      }
      else if (use_cat) {
        cat(data)
        cat('\n')
      }
      else{
        print(data)
      }
      sink()
    }
    if (append == TRUE) {
      print(paste('Output appended to ', output_file))
    }
    
    else{
      print(paste('Output saved at ', output_file))
    }
    
  }
read_configuration <- function() {
  configuration <- yaml.load_file('configuration.yml')
  return(configuration)
}

read_features <- function(configuration) {
  feature_data <- data.frame()
  print("Loading feature data, please wait...")
  for (category in names(configuration$labels)) {
    for (label in configuration$labels[[category]]) {
      cat(paste(label, '\t'))
      for (index in configuration$assignment3$min_index:configuration$assignment3$max_index) {
        # construct file path
        index <- sprintf("%04d", index)
        feature_file_path <-
          paste(
            configuration$assignment3$data_directory,
            label,
            '_',
            index,
            '_features.csv',
            sep = ''
          )
        
        # check if file exists
        if (file.exists(feature_file_path)) {
          feature_data <-
            rbind(feature_data,
                  read.csv(
                    feature_file_path,
                    header = FALSE,
                    sep = '\t'
                  ))
        } else{
          print('')
          print(paste(
            'Error: the feature file ',
            feature_file_path,
            'does not exist!'
          ))
          stopifnot('')# terminate the program
        }
      }
    }
  }
  header <- c('label', 'index', configuration$feature_names)
  names(feature_data) <- header
  print('')
  return (feature_data)
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
  feature_data <<- read_features(configuration)
  
  output_dir <- create_dir(configuration$output_directory)
  output_dir <- create_dir(paste(output_dir, 'section3/', sep = ''))
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
remove_file <- function(file_directory, file_name) {
  file_path <- paste(file_directory, file_name, sep = '')
  
  # reference https://stackoverflow.com/questions/14219887/how-to-delete-a-file-with-r
  if (file.exists(file_path)) {
    file.remove(file_path)
  }
}

# Section 3 ------------------------------------------------------------------
start_section3()

# Task 1 ------------------------------------------------------------------
start_task(1)

out_of_bag_estimate_bagging <- function(data, bag_size) {
  data <- data[sample(nrow(data)), ]# shuffle the data
  
  # reference https://www.rdocumentation.org/packages/ipred/versions/0.4-0/topics/bagging
  bag <- bagging(
    formula = label ~ .,
    data = data,
    nbagg = bag_size,
    coob = TRUE,
    # COMPUTE out of bag
    control = rpart.control(minsplit = 2)
  )
  accuracy <- 1 - bag$err
  return (accuracy)
}
cross_validation_bagging <- function(kfold, data, bag_size) {
  data <- data[sample(nrow(data)), ]# shuffle the data
  
  # reference https://bradleyboehmke.github.io/HOML/bagging.html
  # reference https://www.rdocumentation.org/packages/caret/versions/4.47/topics/train
  bag <- train(
    label ~ .,
    data = data,
    method = "treebag",
    trControl = trainControl(method = "cv", number = kfold),
    nbagg = bag_size,
    control = rpart.control(minsplit = 2)
  )
  return(bag$results$Accuracy)
}

data <- feature_data[, c(1, 3:10)] # extract data for this task
bag_sizes <- c(25, 50, 200, 400, 800)
result <- data.frame()

# out of bag estimation
print('Performing out of bag estimation, please wait...')
for (bag_size in bag_sizes) {
  print(paste('Bagging size =', bag_size))
  
  accuracy <- out_of_bag_estimate_bagging(data, bag_size)
  out_of_bag_result <- data.frame(
    evaluation.method = 'Out of Bag Estimate',
    accuracy = accuracy,
    bag.size = bag_size
  )
  result <- rbind(result, out_of_bag_result)
}

# Cross validation
print('Performing 5 fold Cross validation, please wait...')
for (bag_size in bag_sizes) {
  print(paste('Bagging size =', bag_size))
  
  kfold <- 5
  accuracy <- cross_validation_bagging(kfold, data, bag_size)
  cross_validation_result <-
    data.frame(
      evaluation.method = 'Cross Validation',
      accuracy = accuracy,
      bag.size = bag_size
    )
  result <- rbind(result,  cross_validation_result)
}

# save the result
print_save(output_dir, 'Bagging Accuracy.txt', result)

# visualise the result
plot <-
  ggplot(data = result, aes(x = bag.size, y = accuracy, group = evaluation.method)) +
  geom_line(aes(color = evaluation.method)) +
  geom_point(aes(color = evaluation.method))
print_save(output_dir, 'Bagging Accuracy.jpeg', plot)

finish_task(1)
# Task 2 ------------------------------------------------------------------
start_task(2)

data <- feature_data[, c(1, 3:10)] # extract data for this task
bag_sizes <- c(25, 50, 200, 400, 800)
kfold <- 5
result <- data.frame()

# reference https://rpubs.com/phamdinhkhanh/389752
# reference https://www.rdocumentation.org/packages/caret/versions/6.0-84/topics/trainControl
# define the method of training - 5 fold cross validation, grid of tuning parameters
control <-
  trainControl(method = 'cv',
               number = kfold         ,
               search = 'grid')


# reference https://www.rdocumentation.org/packages/randomForest/versions/1.0/topics/randomForest

# Number of trees to grow
ntree <- seq(25, 400, by = 25)

# Number of variables randomly sampled as candidates at each split.
mtry <-  c(2, 4, 6, 8)

total_result <- data.frame()

print('Tuning parameters: ntree & mtry')
for (number_of_trees in ntree) {
  print(paste('Performing ntree =', number_of_trees))
  # reference https://www.rdocumentation.org/packages/caret/versions/4.47/topics/train
  # reference https://stats.stackexchange.com/questions/50210/caret-and-randomforest-number-of-trees
  # reference https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/expand.grid
  grid_search <- train(
    label ~ .,
    data = data,
    method = 'rf',
    ntree = number_of_trees,
    trControl = control,
    tuneGrid =  expand.grid(.mtry = mtry)
  )
  
  # save the result
  result <- grid_search$results[, c('mtry', 'Accuracy')]
  result$ntree <- number_of_trees
  total_result <- rbind(total_result, result)
}

# save the result of the tuning grid
print_save(output_dir, 'Tuning ntree mtry grid.txt', total_result)

# Find the best tune
best_tune <- total_result[which.max(total_result$Accuracy), ]
print_save(output_dir, 'Tuning ntree mtry grid.txt', 'Best Tune:', append = TRUE)

print_save(output_dir, 'Tuning ntree mtry grid.txt', best_tune, append = TRUE)


# visualise the result, by drawing lines for each mtry
total_result$mtry <- as.factor(total_result$mtry)
plot <-
  ggplot(data = total_result, aes(x = ntree, y = Accuracy, group =
                                    mtry)) +
  geom_point(aes(color = mtry)) +
  geom_line(aes(color = mtry))

print_save(output_dir, 'Tuning ntree mtry accuracy figure.jpeg', plot)

finish_task(2, reserved_varialbes = c('best_tune')) # save the best tune parameters for task 3
# Task 3 ------------------------------------------------------------------
start_task(3)

repeat_cross_validation_random_forest <-
  function(data, repeat_times, ntree, mtry, kfold) {
    control <-
      trainControl(method = 'cv', number = kfold)
    
    result <- c()
    
    print(
      paste(
        'Performing random forest',
        repeat_times,
        'times using cross validation with ntree =',
        ntree,
        ', mtry =',
        mtry
      )
    )
    
    
    for (i in 1:repeat_times) {
      cat(paste(i, '\t')) # display the progress
      
      # train random forest model
      random_forest <- train(
        label ~ .,
        data = data,
        method = 'rf',
        trControl = control,
        ntree =  ntree,
        tuneGrid =  expand.grid(.mtry = mtry)
      )
      
      # save the accuracy
      accuracy <- random_forest$results$Accuracy
      result <- c(result, accuracy)
    }
    return(result)
  }

data <- feature_data[, c(1, 3:10)] # extract data for this task

result <-
  repeat_cross_validation_random_forest(
    data = data,
    repeat_times = 20,
    ntree = best_tune$ntree,
    mtry = as.numeric(best_tune$mtry),
    kfold = 5
  )

print_save(output_dir,'20 Accuracy values.txt',result)
# Calculate meand and SD
output<-paste('The mean of the accuracies is', mean(result))
output<-paste(output,'\nThe standard deviation of the accuracies is', sd(result))
print_save(output_dir,'Mean and SD.txt',output,use_cat = TRUE)

finish_task(3, reserved_varialbes = c('best_tune', 'result')) # save the result of the 8-feature model for task 4

# Task 4 ------------------------------------------------------------------
start_task(4)

result_8_features <- result

data <- feature_data[, c(1, 3:10)] # extract data for this task
kfold <- 5

# Fit all 8 features int bagging trees with same 'number of trees' in task 3
print("Analysing the importances of these 8 features using bagging trees. Please wait...")
bag <- train(
  label ~ .,
  data = data,
  method = "treebag",
  trControl = trainControl(method = "cv", number = kfold),
  nbagg = best_tune$ntree,
  control = rpart.control(minsplit = 2)
)

# Visualise the importances of these 8 features
# reference https://www.rdocumentation.org/packages/mixOmics/versions/6.3.2/topics/vip
importance_of_predictors <- vip(bag, num_features = 8)
print_save(output_dir,
           'Importance of Predictors.jpeg',
           importance_of_predictors)

# find the the least important feature
min_importance <- which.min(importance_of_predictors$data$Importance)
least_importance_feature <-
  importance_of_predictors$data$Variable[min_importance]
print(paste('The least important feature is', least_importance_feature))

# drop the least important feature
seven_feature_data <-
  data[, !(names(data) %in% least_importance_feature)]

result_7_features <-
  repeat_cross_validation_random_forest(
    data = seven_feature_data,
    repeat_times = 20,
    ntree = best_tune$ntree,
    mtry = as.numeric(best_tune$mtry),
    kfold = kfold
  )

# Now, we have got 20 accuracies in 7-feature model and 8-feature model, respectively
# As the sample size is too small, we perform t test

# Summarise all data
accuracies <-
  data.frame(seven.feature = result_7_features, eight.feature = result_8_features)
print_save(output_dir, 'Accuracies summary.txt', summary(accuracies))

# reference https://www.rdocumentation.org/packages/stats/versions/3.6.1/topics/t.test

print('Performing T Test to these two groups of accuracies')
H0<-'H0 = The true mean of the accuracies in these two models are the same'
HA<-'HA = 7-feature model significantly less accurate than the 8-feature model'
print(H0)
print(HA)
t_test <-
  t.test(
    x = accuracies$seven.feature,
    y = accuracies$eight.feature,
    alternative = 'less'
  )
print_save(output_dir, 'T Test result.txt', t_test, use_cat = FALSE)

print('Conclusion:')
if (t_test$p.value < 0.05) {
  print(HA)
} else{
  print(H0  )
}

finish_task(4)
finish_section3()