# Set up ------------------------------------------------------------------
start_section2 <- function() {
  print(paste(
    strrep('-', times = 20),
    "Starting Section 1",
    strrep('-', times = 20)
  ))
  library(yaml)
  library(e1071)
  library(caret)
  library(ggplot2)
  library(class)
}
print_save <-
  function(output_directory,
           file_name,
           data,
           append = FALSE) {
    output_file <- paste(output_directory, file_name, sep = '')
    print(data)
    
    if (class(data)[1] == 'gg') {
      ggsave(output_file, dpi = 400)
    } else{
      # reference https://stackoverflow.com/tasks/30371516/how-to-save-summarylm-to-a-file/30371944
      
      sink(output_file, append = append)
      cat(data)
      cat('\n')
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
remove_file<-function(file_directory,file_name){
  file_path <- paste(file_directory, file_name, sep = '')
  
  # reference https://stackoverflow.com/questions/14219887/how-to-delete-a-file-with-r
  if(file.exists(file_path)){
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
  result <- paste('k =', k, '   accuracy =', accuracy)
  print_save(output_dir, 'knn result.txt', result, append = TRUE)
}
finish_task(task_number = 1)
# Task 2 ------------------------------------------------------------------
start_task(task_number = 2)

# Extract the data which will be used
data <- feature_data[, c(1, 3:10)]

remove_file(output_dir,  'knn accuracy on test data.txt')
best_k<-1
best_accuracy<-0
for (k in seq(1, 59, by = 2)) {
  # cross validation, assign observations to folds
  kfold <- 5
  data <- data[sample(nrow(data)), ]# shuffle the data
  data$folds <-
    cut(seq(1, nrow(data)), breaks = kfold, labels = FALSE)
  overall_correctness <- 0
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
        test =valid_predictors,
        cl = train.labels,
        k = k
      )
    correctness <- prediction == valid_true_label
    accuracy <- mean(correctness)
    overall_correctness <- overall_correctness + accuracy
    
    
  }
  # save the result for the current k value
  overall_correctness <- overall_correctness / kfold
  result <- paste('k =', k, '   accuracy =', overall_correctness)
  print_save(output_dir, 'knn accuracy on test data.txt', result, append = TRUE)
  
  # find best k value
  if(overall_correctness>best_accuracy){
    best_accuracy<-overall_correctness
    best_k<-k
  }
  
}
result<-paste('Best Performance: k =', best_k, '   accuracy =', best_accuracy)
print_save(output_dir,'knn accuracy on test data.txt', result, append = TRUE)

####
