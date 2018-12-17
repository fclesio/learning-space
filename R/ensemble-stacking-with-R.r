# An Ensemble Purview
# Here we have 3 datasets wuth the following distributions
# Train = 50%, Test = 25% and Ensenble = 25%
load("C:/Users/FYD/Desktop/EnsembleMachineLearningusingR_Code/Chapter01/Data/GC2.RData")
set.seed(12345)

# Create te sample object that have the index for get the 
# dataframe for each position in the train, test and stack 
# values
Train_Test_Stack <- sample(c("Train","Test","Stack"),
                           nrow(GC2),
                           replace = TRUE,
                           prob = c(0.5,0.25,0.25))

# Get all values based in the index to make the split
GC2_Train <- GC2[Train_Test_Stack=="Train",]
GC2_Test  <- GC2[Train_Test_Stack=="Test",]
GC2_Stack <- GC2[Train_Test_Stack=="Stack",]

# Set label name and Exhogenous as a meta name to
# pass to the model as the name of the features
Endogenous <- 'good_bad'
Exhogenous <- names(GC2_Train)[names(GC2_Train) != Endogenous]

# Create a caret control object to control the number of 
# cross-validations performed.
myControl <- trainControl(method='cv',
                          number=10,
                          returnResamp='none')

# Train all the ensemble models with GC2_Train
# This is the first stage of the ensemble stacking
# Here we have the vanilla models that will
# generate the first layer of predictions
model_NB <- train(GC2_Train[,Exhogenous],
                  GC2_Train[,Endogenous],
                  method='naive_bayes',
                  trControl=myControl)

model_rpart <- train(GC2_Train[,Exhogenous],
                     GC2_Train[,Endogenous], 
                     method='rpart',
                     trControl=myControl)

model_glm <- train(GC2_Train[,Exhogenous],
                   GC2_Train[,Endogenous], 
                   method='glm',
                   trControl=myControl)


# Get predictions for each ensemble model for two last data sets
# and add them back to themselves
GC2_Test$NB_PROB <- predict(object=model_NB,
                            GC2_Test[,Exhogenous],
                            type="prob")[,1]

GC2_Test$rf_PROB <- predict(object=model_rpart,
                            GC2_Test[,Exhogenous],
                            type="prob")[,1]

GC2_Test$glm_PROB <- predict(object=model_glm, 
                             GC2_Test[,Exhogenous],
                             type="prob")[,1]

GC2_Stack$NB_PROB <- predict(object=model_NB,
                             GC2_Stack[,Exhogenous],
                             type="prob")[,1]

GC2_Stack$rf_PROB <- predict(object=model_rpart,
                             GC2_Stack[,Exhogenous],
                             type="prob")[,1]

GC2_Stack$glm_PROB <- predict(object=model_glm,
                              GC2_Stack[,Exhogenous],
                              type="prob")[,1]



# See how each individual model performed on its own
# The idea here its to get the probabilities
# and see the AUC in comparison with the test data
AUC_NB <- roc(GC2_Test[,Endogenous], GC2_Test$NB_PROB )
AUC_NB$auc

AUC_rf <- roc(GC2_Test[,Endogenous], GC2_Test$rf_PROB )
AUC_rf$auc

AUC_glm <- roc(GC2_Test[,Endogenous], GC2_Test$glm_PROB )
AUC_glm$auc

# Stacking it together, it means that we'll 
# include the probability columns (NB_PROB, rf_PROB and glm_PROB)
# To the exhogenous variables. With that we'll include the
# the vanilla predictions to enhance our model
Exhogenous2 <- names(GC2_Stack)[names(GC2_Stack) != Endogenous]

Stack_Model <- train(GC2_Stack[,Exhogenous2],
                     GC2_Stack[,Endogenous], 
                     method='naive_bayes',
                     trControl=myControl)

Stack_Prediction <- predict(object=Stack_Model,
                            GC2_Test[,Exhogenous2],
                            type="prob")[,1]


Stack_AUC <- roc(GC2_Test[,Endogenous],Stack_Prediction)
Stack_AUC$auc
