
# Set up ------------------------------------------------------------------
start_section1<-function(){
  print("Starting Section 1")
  library(yaml)
  
  
}
print_save<-function(output_directory,file_name,data){
  # reference https://stackoverflow.com/questions/30371516/how-to-save-summarylm-to-a-file/30371944
  print(data)
  sink(paste(output_directory,file_name,sep = ''))
  print(data)
  sink()
}
read_configuration<-function(){
  configuration<-yaml.load_file('configuration.yml')
  return(configuration  )
}

read_features<-function(feature_file){
  read.csv(feature_file,header=TRUE,sep = '\t')
}

is_living<-function(label_name,configuration){
  for (each in configuration$labels$living){
    if(each==label_name){
      return(1)
    }
  }
  return (0)
    
}
create_dir<-function(directory){
  if(!dir.exists(directory)){
    dir.create(directory)
  }
  return (directory)
}
start_question<-function(question_number){
  print(paste("Starting Question",question_number))
  configuration<<-read_configuration()
  feature_data<<-read_features(configuration$assignment2$features_file)
  output_dir<-create_dir(configuration$output_directory)
  output_dir<-create_dir(paste(output_dir,'section1/',sep=''))
  output_dir<<-create_dir(paste(output_dir,'question',question_number,'/',sep=''))
}
finish_question<-function(question_number,remain_varialbes=c()){
  print(paste("Question",question_number,'Finished'))
  
  all_variables<-ls(envir=.GlobalEnv) #reference https://www.rdocumentation.org/packages/base/versions/3.6.1/topics/ls
  remove_variables=all_variables[!all_variables %in% remain_varialbes]
  rm(list =remove_variables,envir=.GlobalEnv)
}

# Section 1 ------------------------------------------------------------------
start_section1()

# Question 1 ------------------------------------------------------------------

start_question(question_number = 1)
head(feature_data)
living<-sapply(feature_data$label, is_living,configuration=configuration)

data<-cbind.data.frame(verticalness=feature_data$verticalness,living)
summary(data)
glmfit<<-glm(living~verticalness,family='binomial',data=data)
print_save(output_dir,'glm_summary.txt', summary(glmfit))
finish_question(question_number = 1,remain_varialbes = c('glmfit')) # save the model for question 2
# Question 2 ------------------------------------------------------------------
