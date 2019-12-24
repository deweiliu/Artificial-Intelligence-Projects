# Helper packages
library(dplyr)       # for data wrangling
library(ggplot2)     # for awesome plotting
library(doParallel)  # for parallel backend to foreach
library(foreach)     # for parallel processing with for loops

# Modeling packages
library(caret)       # for general model fitting
library(rpart)       # for fitting decision trees
library(ipred)       # for fitting bagged decision trees
# Helper packages
library(dplyr)       # for data wrangling
library(ggplot2)     # for awesome plotting

# Modeling packages
library(rpart)       # direct engine for decision tree application
library(caret)       # meta engine for decision tree application

# Model interpretability packages
library(rpart.plot)  # for plotting decision trees
library(vip)         # for feature importance
library(pdp)         # for feature effects
set.seed(123)

# train bagged model
ames_bag1 <- bagging(
  formula = Sale_Price ~ .,
  data = ames_train,
  nbagg = 100,  
  coob = TRUE,
  control = rpart.control(minsplit = 2, cp = 0)
)

ames_bag1


? cv.tree
cv.carseats = cv.tree(tree.carseats, FUN = prune.misclass, K = 12)

cv.carseats

min_class_error_rate = cv.carseats$dev[which.min(cv.carseats$dev)]
min_class_error_rate
final_terminal_nodes = cv.carseats$size[which.min(cv.carseats$dev)]
final_terminal_nodes

par (mfrow = c(1 , 2))
plot(cv.carseats$size , cv.carseats$dev , type = "b")
plot(cv.carseats$k , cv.carseats$dev , type = "b")
# Pruning tree nodes
prune.carseats = prune.misclass (tree.carseats , best = 9)
plot(prune.carseats)
text(prune.carseats , pretty = 0)
summary(prune.carseats)
print(prune.carseats)
prune.carseats

tree.pred = predict (prune.carseats, Carseats.test , type = "class")
table (tree.pred , High.test)

#https://machinelearningmastery.com/tune-machine-learning-algorithms-in-r/
library(randomForest)
library(mlbench)
library(caret)
library(e1071)

# Load Dataset
data(Sonar)
dataset <- Sonar
x <- dataset[,1:60]
y <- dataset[,61]

#10 folds repeat 3 times
control <- trainControl(method='repeatedcv', 
                        number=10, 
                        repeats=3)
#Metric compare model is Accuracy
metric <- "Accuracy"
set.seed(123)
#Number randomely variable selected is mtry
mtry <- sqrt(ncol(x))
tunegrid <- expand.grid(.mtry=mtry)
rf_default <- train(Class~., 
                    data=dataset, 
                    method='rf', 
                    metric='Accuracy', 
                    tuneGrid=tunegrid, 
                    trControl=control)
print(rf_default)
#https://rpubs.com/phamdinhkhanh/389752