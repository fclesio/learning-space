install.packages("caret")
install.packages("earth")

library(caret)
library(earth)

# Get data
tambore_parnaiba_2013_data <- read.csv('https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/imoveis-tambore-parnaiba-2013.csv');

# Check data
tambore_parnaiba_2013_data

# Eliminate Bairro variable
tambore_parnaiba_2013_data$Bairro <- NULL

# Fit model(MARS)
fit <- earth(ValorVenda~.
             ,tambore_parnaiba_2013_data # Base de dados
             ,trace = 1                  # Trace: Detalhes do runtime do algoritmo
             ,ncross= 50                 # Número de validações cruzadas
             ,nfold = 10                 # Número de folds para cross validation
             ,pmethod="backward"         # Nesse caso o prunning será da última variável do modelo para a primeira
             ,nprune=15                  # Número de termos máximos após o prunning
             ,varmod.method="lm")        #Variance Model: Opção para a escolha do modelo de variancia (Nesse caso será o modelo linear, mas o glm pode ser escolhido.)


# Summarize the fit
summary(fit,digit=3)


# Plot
plotmo(fit)

# Variable importance
evimp(fit)


# New dataset called "data"
data <- tambore_parnaiba_2013_data

# Eliminate variables
data$ValorVenda <- NULL
data$Bairro <- NULL

# Predictions (Fitting data over the new dataset)
predictions <- predict(fit, data)

# Change the name of variable for binding
colnames(predictions) <- c("PredictValorVenda")

# See results
predictions


# Binding predictions with original data
predit <- cbind(tambore_parnaiba_2013_data,predictions)

# Only the two variables
predit <- cbind(predit$ValorVenda, predit$PredictValorVenda) 

# Name ajustments
colnames(predit) <- c("ValorVenda","PredictValorVenda")

# Convert to a dataframe
FinalPredictions <-as.data.frame(predit)


# Final Predictions
FinalPredictions$resuduals <- FinalPredictions$ValorVenda - FinalPredictions$PredictValorVenda

# Final table with results
FinalPredictions

# Root Mean Square Error
rmse <- sqrt(mean(((FinalPredictions$ValorVenda - FinalPredictions$PredictValorVenda)^2)))

# Show results
rmse
