# Set up ------------------------------------------------------------------
start_section2 <- function() {
  print(paste(
    strrep('-', times = 20),
    "Starting Section 2",
    strrep('-', times = 20)
  ))
  library(yaml)
  library(e1071)
  library(caret)
  library(ggplot2)
  library(class)
  library(scales)
  
}
finish_section2<-function(){
  print(paste(
    strrep('-', times = 20),
    "Section 2 Finished",
    strrep('-', times = 20)
  ))
  rm(list= ls(envir = .GlobalEnv),envir = .GlobalEnv)
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
      if (use_cat) {
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
  
  feature_data <<- read_features(configuration)
  
  output_dir <- create_dir(configuration$output_directory)
  output_dir <- create_dir(paste(output_dir, 'section2/', sep = ''))
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
# Section 2 ------------------------------------------------------------------
start_section2()
# Task 1 ------------------------------------------------------------------
start_task(task_number = 1)

# Extract the data which will be used
data <- feature_data[, c(1, 3:10)]

# training data
train.predictors <- data[,-1]
train.labels <- data[, 1]

error_rates <- data.frame()

remove_file(output_dir, 'knn result.txt')

for (k in seq(1, 59, by = 2)) {
  prediction <-
    knn(
      train = train.predictors,
      test = train.predictors,
      cl = train.labels,
      k = k
    )
  correctness <- prediction == train.labels
  accuracy <- mean(correctness)
  error_rate <- 1 - accuracy
  error_rates <-
    rbind(error_rates, data.frame(k = k, training.errors = error_rate))
  
  result <- paste('k =', k, '   accuracy =', accuracy)
  print_save(output_dir, 'knn result.txt', result, append = TRUE)
}
finish_task(task_number = 1,
            reserved_varialbes = c('error_rates'))
# Task 2 ------------------------------------------------------------------
start_task(task_number = 2)

# Extract the data which will be used
data <- feature_data[, c(1, 3:10)]

remove_file(output_dir,  'knn accuracy on test data.txt')
best_k <- 1
best_accuracy <- 0
cross_validated_errors <- data.frame()
for (k in seq(1, 59, by = 2)) {
  # cross validation, assign observations to folds
  kfold <- 5
  data <- data[sample(nrow(data)), ]# shuffle the data
  data$folds <-
    cut(seq(1, nrow(data)), breaks = kfold, labels = FALSE)
  overall_accuracy <- 0
  for (i in 1:kfold) {
    # split data for training and validation
    train_objects <- data[data$folds != i,]
    valid_objects <- data[data$folds == i,]
    
    # Extract predictors and labels in the training data
    train.predictors <- train_objects[, -1]
    train.labels <- train_objects[, 1]
    
    # Extract predictors and labels in the validation data
    valid_predictors <- valid_objects[, -1]
    valid_true_label <- valid_objects[, 1]
    
    prediction <-
      knn(
        train = train.predictors,
        test = valid_predictors,
        cl = train.labels,
        k = k
      )
    correctness <- prediction == valid_true_label
    accuracy <- mean(correctness)
    
    overall_accuracy <- overall_accuracy + accuracy
    
    
  }
  # save the result for the current k value
  overall_accuracy <- overall_accuracy / kfold
  result <- paste('k =', k, '   accuracy =', overall_accuracy)
  print_save(output_dir, 'knn accuracy on test data.txt', result, append = TRUE)
  
  error_rate <- 1 - overall_accuracy
  cross_validated_errors <-
    rbind(cross_validated_errors,
          data.frame(cross.validated.errors = error_rate))
  
  # find best k value
  if (overall_accuracy > best_accuracy) {
    best_accuracy <- overall_accuracy
    best_k <- k
  }
  
}
# save cross validation accuracy
result <-
  paste('Best Performance: k =', best_k, '   accuracy =', best_accuracy)
print_save(output_dir, 'knn accuracy on test data.txt', result, append = TRUE)

# build error rates table/dataframe
error_rates <- cbind(error_rates, cross_validated_errors)
error_rates$inversed.k <- 1 / (error_rates$k)
print_save(output_dir,
           'error rates summary - training and testing.txt',
           summary(error_rates),use_cat = FALSE)

min_validated_error <- min(error_rates$cross.validated.errors)

#### plot the figure
# feed data
plot <- ggplot(data = error_rates)

# add training error rates line
plot <-
  plot + geom_point(aes(x = inversed.k, y = training.errors), col = 'dark green') +
  geom_line(aes(x = inversed.k, y = training.errors), col = 'green')

# add validation error rates line
plot <-
  plot +  geom_point(aes(x = inversed.k, y = cross.validated.errors), col = 'dark orange') +
  geom_line(aes(x = inversed.k, y = cross.validated.errors), col = 'orange') +
  geom_hline(yintercept = min_validated_error)

# add minimum validation error rate line
plot <- plot +
  geom_text(aes(
    0,
    min_validated_error,
    label = min_validated_error,
    vjust = -1,
    hjust = -1
  )) # reference https://www.rdocumentation.org/packages/ggplot2/versions/0.9.0/topics/geom_hline

# scale x axis
plot <-
  plot + scale_x_continuous(trans = log2_trans()) # reference https://www.rdocumentation.org/packages/scales/versions/0.4.1

####
print_save(output_dir, 'error rates.jpeg', plot)

finish_task(task_number = 2,
            reserved_varialbes = c('best_k')) # save the best_k in knn cross validation test for task 3
# Task 3 ------------------------------------------------------------------
start_task(task_number = 3)

# Extract the data which will be used
data <- feature_data[, c(1, 3:10)]

# cross validation, assign observations to folds
kfold <- 5
data <- data[sample(nrow(data)), ]# shuffle the data
data$folds <-
  cut(seq(1, nrow(data)), breaks = kfold, labels = FALSE)
overall_accuracy <- 0

knn_result <- data.frame() # store the prediction and the true label

for (i in 1:kfold) {
  # split data into training and validation
  train_objects <- data[data$folds != i,]
  valid_objects <- data[data$folds == i,]
  
  # Extract predictors and labels in the training data
  train.predictors <- train_objects[, -1]
  train.labels <- train_objects[, 1]
  
  # Extract predictors and labels in the validation data
  valid_predictors <- valid_objects[, -1]
  valid_true_label <- valid_objects[, 1]
  
  prediction <-
    knn(
      train = train.predictors,
      test = valid_predictors,
      cl = train.labels,
      k = best_k
    )
  
  # collect the result
  knn_result <-
    rbind(knn_result,
          data.frame(prediction = prediction, actual = valid_true_label))
  
}

# apply confusion matrix and save the output
print_save(
  output_dir,
  'confusion matrix for knn prediction.txt',
  paste('Using k =', best_k, 'to perform knn cross validation test')
)
analysis <-
  confusionMatrix(data = knn_result$prediction, reference = knn_result$actual)

print_save(
  output_dir,
  'confusion matrix for knn prediction.txt',
  analysis,
  append = TRUE,
  use_cat = FALSE
)
finish_task(3)
# Finish section 2  ------------------------------------------------------------------
finish_section2()
