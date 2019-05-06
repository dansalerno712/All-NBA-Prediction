rm(list = ls())

library(kknn)
library(e1071)
library(rpart)
library(randomForest)
library(caret)
library(C50)
library(neuralnet)

# for consistent runs of the classifiers if necessary
# eg for comparing changes to this script across runs
set.seed(400)

# Functions ----
mmnorm <-function(x,minx,maxx) {
  z<-((x-minx)/(maxx-minx))
  return(z) 
}

# Read in data ----
data <- read.csv("finalData.csv")

# Clean data ----
# get rid of useless columns
# GS is included here because it has some NAs and is mostly captured by G and MP
data <- subset(data, select = -c(X, Tm, Lg, GS, Age))
data[, "allnba"] <- factor(data[, "allnba"])
data[, "allstar"] <- factor(data[, "allstar"])

# Normalize the non factor columns
data <- as.data.frame(lapply(data, function(x) {
  if (class(x) == "factor") {
    return(x)
  } else {
    return(mmnorm(x, min(x, na.rm = T), max(x, na.rm = T)))
  }
}))

this_year <- "2018-19"

# Create model_data, predicition_data, and training/test data ----
data_this_year <- data[data$Season == this_year,]
model_data <- data[data$Season != this_year,]

idx <- sample(nrow(model_data), as.integer(.70 * nrow(model_data)))
training <- model_data[idx,]
test <- model_data[-idx,]

# certain classifiers require data with no NAs, so create them here
# NOTE: we do na.omit for data_this_year, but this should ideally
# be free of any NAs since there is so little data for it
clean_model_data <- na.omit(model_data)
clean_training <- na.omit(training)
clean_test <- na.omit(test)
clean_data_this_year <- na.omit(data_this_year)

# intitial setup of output file ----
out <- as.data.frame(cbind(Player = as.character(data_this_year$Player)))

# KNN ----
# try k between 1 and 50 and grab the best model
max_k <- 100
knn_error_rates <- rep(0, max_k)

for(i in 1:max_k) {
  knn_model <- kknn(formula = allnba ~ . - Player - Season, train = clean_training, test = clean_test, k=i, kernel = "triangular")
  knn_fit <- fitted(knn_model)
  ftable(Predicted = knn_fit, Actual = clean_test$allnba)
  wrong <- sum(knn_fit != clean_test$allnba)
  knn_error_rate <- wrong / length(knn_fit)
  knn_error_rates[i] = knn_error_rate
}

plot(1:max_k, knn_error_rates)
# grab best k
best_k = which.min(knn_error_rates)

# redo knn with best k
knn_model <- kknn(formula = allnba ~ . - Player - Season, train = clean_training, test = clean_test, k=best_k, kernel = "triangular")
knn_fit <- fitted(knn_model)
ftable(Predicted = knn_fit, Actual = clean_test$allnba)
wrong <- sum(knn_fit != clean_test$allnba)
knn_error_rate <- wrong / length(knn_fit)
knn_error_rate

# predict this years all nba
knn_predict <- kknn(formula = allnba ~ . - Player - Season, train = clean_model_data, test = clean_data_this_year, k=best_k, kernel = "triangular")
knn_allnba_prob <- knn_predict$prob[,2]
out <- cbind(out, knn_allnba_prob)


# Naive Bayes ----
nb_model <- naiveBayes(allnba ~ . - Player - Season, data = training)
nb_pred <- predict(nb_model, test)
ftable(Predicted = nb_pred, Actual = test$allnba)
wrong <- sum(nb_pred != test$allnba)
nb_error_rate <- wrong / length(nb_pred)
nb_error_rate

nb_model_predict <- naiveBayes(allnba ~ . - Player - Season, data = model_data)
nb_pred_predict <- predict(nb_model_predict, data_this_year, "raw")
nb_allnba_prob <- nb_pred_predict[,2]
out <- cbind(out, nb_allnba_prob)

# Random forest ----
rf_model <- randomForest(allnba ~ . - Player - Season, clean_training)
rf_pred <- predict(rf_model, clean_test)
ftable(Predicted = rf_pred, Actual = clean_test$allnba)
wrong <- sum(rf_pred != clean_test$allnba)
rf_error_rate <- wrong / length(rf_pred)
rf_error_rate

rf_model_predict <- randomForest(allnba ~ . - Player - Season, data = clean_model_data)
rf_pred_predict <- predict(rf_model_predict, clean_data_this_year, "prob")
rf_allnba_prob <- rf_pred_predict[,2]
out <- cbind(out, rf_allnba_prob)

# SVM ----
svm_model <- svm(allnba ~ . - Player - Season, clean_training)
svm_pred <- predict(svm_model, clean_test)
ftable(Predicted = svm_pred, Actual = clean_test$allnba)
wrong <- sum(svm_pred != clean_test$allnba)
svm_error_rate <- wrong / length(svm_pred)
svm_error_rate

svm_model_predict <- svm(allnba ~ . - Player - Season, data = clean_model_data, probability = T)
svm_pred_predict <- predict(svm_model_predict, clean_data_this_year, probability = T)
svm_allnba_prob <- attr(svm_pred_predict, "probabilities")[,1]
out <- cbind(out, svm_allnba_prob)

# C50 ----
# remove the first 2 columns because c50 complains about it
c50_model <- C5.0(allnba ~ ., data = training[,c(-1, -2)])
c50_pred <- predict(c50_model, test, type="class")
ftable(Predicted = c50_pred, Actual = test$allnba)
wrong <- sum(c50_pred != test$allnba)
c50_error_rate <- wrong / length(c50_pred)
c50_error_rate

c50_model_predict <- C5.0(allnba ~ ., data = model_data[,c(-1, -2)], probability = T)
c50_pred_predict <- predict(c50_model_predict, data_this_year, type="prob")
c50_allnba_prob <- c50_pred_predict[,2]
out <- cbind(out, c50_allnba_prob)

# ANN ---
# neuralnet needs all numeric, so recreate all the necessary data here
ann_training <- clean_training
ann_training$allnba <- ifelse(ann_training$allnba == "0", 0, 1)
ann_training$allstar <- ifelse(ann_training$allstar == "0", 0, 1)

ann_test <- clean_test
ann_test$allnba <- ifelse(ann_test$allnba == "0", 0, 1)
ann_test$allstar <- ifelse(ann_test$allstar == "0", 0, 1)

ann_model_data <- clean_model_data
ann_model_data$allnba <- ifelse(ann_model_data$allnba == "0", 0, 1)
ann_model_data$allstar <- ifelse(ann_model_data$allstar == "0", 0, 1)

ann_data_this_year <- clean_data_this_year
ann_data_this_year$allnba <- ifelse(ann_data_this_year$allnba == "0", 0, 1)
ann_data_this_year$allstar <- ifelse(ann_data_this_year$allstar == "0", 0, 1)
    
# start building the models now  
# make sure to remove the first two columns (Season/Player) because anns dont like non numbers
ann_model <- neuralnet(allnba ~ ., data = ann_training[,c(-1, -2)])
ann_score <- compute(ann_model, ann_test)
ftable(Predicted = round(ann_score$net.result[,1]), Actual = ann_test$allnba)
wrong <- sum(round(ann_score$net.result[,1]) != ann_test$allnba)
ann_error_rate <- wrong / length(ann_test$allnba)
ann_error_rate

ann_model_predict <- neuralnet(allnba ~ ., data = ann_model_data[,c(-1, -2)])
ann_predict_score <- compute(ann_model, ann_data_this_year)
# the probability is just the score from the ann, since there is no
# predict with method="prob" for ann
ann_allnba_prob <- ann_predict_score$net.result[,1]
out <- cbind(out, ann_allnba_prob)

# Average all probabilities ----
# grab all the classifier averages
all_nba_avg <- rowMeans(out[,2:ncol(out)])
out$all_nba_avg <- all_nba_avg

# Output ----
write.csv(out, "classified.csv")

# Statistics for each model ----
# the caret package is super helpful
confusionMatrix(knn_fit, clean_test$allnba, positive = "1", mode = "everything")
confusionMatrix(nb_pred, test$allnba, positive = "1", mode = "everything")
confusionMatrix(rf_pred, clean_test$allnba, positive = "1", mode = "everything")
confusionMatrix(svm_pred, clean_test$allnba, positive = "1", mode = "everything")
confusionMatrix(c50_pred, test$allnba, positive = "1", mode = "everything")
confusionMatrix(as.factor(round(ann_score$net.result[,1])), as.factor(ann_test$allnba), positive = "1", mode = "everything")

