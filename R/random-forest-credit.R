# Load library
library(randomForest)

# Load info
credit <- read.csv("https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/02%20-%20Classification/default_credit_card.csv")

# Make train and test set (70% Train / 30% Test)
idx <- runif(nrow(credit)) <= .70

credit_train <- credit[idx,]

credit_test <- credit[-idx,]

credit_train$DEFAULT <- as.factor(credit_train$DEFAULT) 

credit_test$DEFAULT <- as.factor(credit_test$DEFAULT) 


nrow(credit_train)

nrow(credit_test)


#Load caret
library(caret)

# Build model with Grid Search to choose the best parameters
control <- trainControl(method="repeatedcv", number=10, repeats=3, search="grid")

# Metrics of evaluation
metric <- "Accuracy"

# Seed for reproductibility
set.seed(12345)

rnorm(3)
# 0.5855288  0.7094660 -0.1093033

# a function of number of remaining predictor variables to use as the mtry parameter in the randomForest call
tunegrid <- expand.grid(.mtry=c(1:15))

#Build model
model_GS <- train(DEFAULT~., data=credit_train, method="rf"
                         ,metric=metric, tuneGrid=tunegrid, trControl=control)
#Print model details
print(model_GS)

#Plot model capabilities
plot(model_GS)


## Need some tunning. It's TOO SLOW!

# rf_gridsearch <- train(Class~., data=dataset, method="rf", metric=metric, tuneGrid=tunegrid, trControl=control)
# print(rf_gridsearch)
# plot(rf_gridsearch)

#model <- randomForest(DEFAULT ~ ., data=credit_train, importance=TRUE
#                      ,na.action=na.omit, method="rf", metric=metric
#                      ,tuneGrid=tunegrid, trControl=control)

# head(credit)

# View the forest results.
# print(output.forest) 

# Importance of each predictor.
# print(importance(fit,type = 2)) 

# how important is each variable in the model
# imp <- importance(rf)
# o <- order(imp[,3], decreasing=T)
# imp[o,]

# CMatrix
# table(data.test$Credit, predict(rf, data.test), dnn=list("actual", "predicted"))