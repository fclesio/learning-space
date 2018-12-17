# The Right Model Dilemma! (Source: From Ensemble Learning with R)
Multiple_Model_Fit <- function(formula,train,testX,testY){
  
  # Data partitioning
  ntr <- nrow(train) # Training size
  nte <- nrow(testX) # Test size
  p <- ncol(testX)
  testY_numeric <- as.numeric(testY)
  
  # Neural Network
  set.seed(12345)
  NN_fit <- nnet(formula, data=train, size=p, trace=FALSE)
  NN_Predict <- predict(NN_fit, newdata=testX, type="class")
  NN_Accuracy <- sum(NN_Predict==testY)/nte
  
  # Logistic Regressiona
  LR_fit <- glm(formula, data=train, family = binomial())
  LR_Predict <- predict(LR_fit, newdata=testX, type="response")
  LR_Predict_Bin <- ifelse(LR_Predict>0.5,2,1)
  LR_Accuracy <- sum(LR_Predict_Bin==testY_numeric)/nte
  
  # Naive Bayes
  NB_fit <- naiveBayes(formula, data=train)
  NB_predict <- predict(NB_fit, newdata=testX)
  NB_Accuracy <- sum(NB_predict==testY)/nte
  
  # Decision Tree
  CT_fit <- rpart(formula, data=train)
  CT_predict <- predict(CT_fit, newdata=testX, type="class")
  CT_Accuracy <- sum(CT_predict==testY)/nte
  
  # Support Vector Machine
  svm_fit <- svm(formula, data=train)
  svm_predict <- predict(svm_fit, newdata=testX, type="class")
  svm_Accuracy <- sum(svm_predict==testY)/nte
  
  Accu_Mat <- matrix(nrow=5,ncol=2)

  Accu_Mat[,1] <- c("Neural Network",
                    "Logistic Regression",
                    "Naive Bayes",
                    "Decision Tree",
                    "Support Vector Machine")
                     
  Accu_Mat[,2] <- round(c(NN_Accuracy,
                          LR_Accuracy,
                          NB_Accuracy,
                          CT_Accuracy,
                          svm_Accuracy),4)
  return(Accu_Mat)
  
}
