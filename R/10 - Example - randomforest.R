library(randomForest)

# download Titanic Survivors data
data <- read.table("http://math.ucdenver.edu/RTutorial/titanic.txt", h=T, sep="\t")
# make survived into a yes/no
data$Survived <- as.factor(ifelse(data$Survived==1, "yes", "no"))                 

# split into a training and test set
idx <- runif(nrow(data)) <= .75
data.train <- data[idx,]
data.test <- data[-idx,]

# train a random forest
rf <- randomForest(Survived ~ PClass + Age + Sex, 
                   data=data.train, importance=TRUE, na.action=na.omit)

# how important is each variable in the model
imp <- importance(rf)
o <- order(imp[,3], decreasing=T)
imp[o,]
#             no      yes MeanDecreaseAccuracy MeanDecreaseGini
#Sex    51.49855 53.30255             55.13458         63.46861
#PClass 25.48715 24.12522             28.43298         22.31789
#Age    20.08571 14.07954             24.64607         19.57423

# confusion matrix [[True Neg, False Pos], [False Neg, True Pos]]
table(data.test$Survived, predict(rf, data.test), dnn=list("actual", "predicted"))
#      predicted
#actual  no yes
#   no  427  16
#   yes 117 195