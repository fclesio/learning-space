# Multivariate Adaptive Regression Splines - MARS

# Mars is an adaptive procedure for regression, and is well suited 
# for high-dimensional (i.e., a large number  of inputs). 
# It can be viewed as a generalization of stepwise linear regression 
# or a modification of the CART procedure to improve the latter’s performance in the regression setting. 

# MARS works by splitting input variables into multiple basis functions and then fitting a linear regression model to those basis functions. The basis
# functions used by MARS come in pairs: f(x) = {x − t if x > t, 0 otherwise} and g(x)
# = {t − x if x < t, 0 otherwise}. These functions are piecewise linear functions. The
# value t is called a knot.

# By default, lm is used to fit models. Note that
# glm can be used instead to allow finer control of the model. The function earth can’t
# cope directly with missing values in the data set. 


#Install packages
install.packages("caret")
install.packages("earth")

#Recall libraries
library(caret)
library(earth)

# Load data
data(longley)

# Check Data
head(longley)

# fit model
fit <- earth(Employed~.
             ,longley
             ,trace = 1           #Trace: shows the details of computation
             ,ncross= 30
             ,nfold = 10
             ,pmethod="backward"
             ,nprune=20
             ,varmod.method="lm") #Variance Model: Choose the variance model (linear model in this case)

# summarize the fit
summary(fit)

# coefficients
# (Intercept)            -1682.60259
# Year                       0.89475
# h(293.6-Unemployed)        0.01226
# h(Unemployed-293.6)       -0.01596
# h(Armed.Forces-263.7)     -0.01470

# Selected 5 of 8 terms, and 3 of 6 predictors
# Termination condition: GRSq -Inf at 8 terms
# Importance: Year, Unemployed, Armed.Forces, GNP.deflator-unused, GNP-unused, Population-unused
# Number of terms at each degree of interaction: 1 4 (additive model)
# GCV 0.2389853    RSS 0.7318924    GRSq 0.9818348    RSq 0.996044


# Estimate variable importances in an earth object
evimp(fit)

# nsubsets   gcv    rss
# Year                4 100.0  100.0
# Unemployed          3  24.1   23.0
# Armed.Forces        2  10.4   10.8

# make predictions
predictions <- predict(fit, longley)


predictions <- predict(fit, longley, type = "prob")   # class probabilities (default))
predictions <- predict(fit, longley, type = "vector") # level numbers
predictions <- predict(fit, longley, type = "class")  # factor
predictions <- predict(fit, longley, type = "matrix") # level number, class frequencies, probabilities

##Results
predictions

# summarize accuracy
rmse <- mean((longley$Employed - predictions)^2)

# Print Root Mean Square Error
print(rmse)

# See Dataset
longley

# Sumary of models
summary(fit, digits = 2)
summary(fit, digits = 2, style = "pmax") # default formatting style prior to earth version 1.4
summary(fit, digits = 2, style = "max")
summary(fit, digits = 2, style = "C")
summary(fit, digits = 2, style = "h")
summary(fit, digits = 2, style = "bf")

# GCV = Generalized Cross Validation (GCV) of the model (summed over all responses).
# The GCV is calculated using the penalty argument. The GCV measure how well each model
# fits

# RSS = Residual sum-of-squares (RSS) of the model (summed over all responses, 
# if y has multiple columns).

# GRSq = 1-gcv/gcv.null. An estimate of the predictive power of the model (calculated
# over all responses, and calculated using the weights argument if it was supplied).
# gcv.null is the GCV of an intercept-only model.
  
# RSq = 1-rss/tss. R-Squared of the model (calculated over all responses, and calculated
# using the weights argument if it was supplied). A measure of how
# well the model fits the training data. Note that tss is the total sum-of-squares,
# sum((y - mean(y))^2). 

# Why does “Termination condition: GRSq -Inf” mean?: It’s not something to especially worry about. 
# It means that the forward pass stopped adding terms because the GRSq got so bad that it was pointless to continue. It’s similar
# to Termination condition: GRSq -10 (Section 3 iv) except that the GRSq was even
# worse than -10. After the backward pass, GRSq will be non-negative.

# MARS has automatically produced a kink in the predicted y to take into account non-linearity. 
# The kink is produced by hinge functions. 
# The hinge functions are the expressions starting with \max (where \max(a,b) is a if a > b, else b). 
# Hinge functions are described in more detail below.

# In this simple example, we can easily see from the plot that y has a non-linear relationship
# with x (and might perhaps guess that y varies with the square of x). 
# However, in general there will be multiple independent variables, 
# and the relationship between y and these variables will be unclear and 
# not easily visible by plotting. We can use MARS to discover that non-linear relationship.

# Plot model selection, cumulative distribution of residuals, 
# residuals versus fitted values, and the residual Q-Q plot for an earth object:
plot(fit)

# The plotmo function plots the predicted model response when varying one or two
# predictors while holding other predictors constant.
plotmo(fit)

# Model Comparison
plot.earth.models (fit, jitter = 0.01)


# Plot variable importance
vi <- evimp(fit)

plot (vi, cex.var = 1,
      type.nsubsets = "l", col.nsubsets = "black", lty.nsubsets = 1,
      type.gcv = "l", col.gcv = 2, lty.gcv = 1,
      type.rss = "l", col.rss = "gray60", lty.rss = 1,
      cex.legend = 1, x.legend = nrow(x), y.legend = x[1,"nsubsets"],
      rh.col = 1)


# Plot the embedded variance model
plot(fit$varmod) 









library(earth)
library(caret)

data(etitanic)

etitanic


a1 <- earth(survived ~ ., 
            data = etitanic,
            glm=list(family=binomial),
            degree = 2,       
            nprune = 5)

etitanic$survived <- factor(ifelse(etitanic$survived == 1, "yes", "no"),
                            levels = c("yes", "no"))

a2 <- train(survived ~ ., 
            data = etitanic, 
            method = "earth",
            tuneGrid = data.frame(degree = 2, nprune = 5),
            trControl = trainControl(method = "none", 
                                     classProbs = TRUE))




predict(a1, head(etitanic), type = "response")

predict(a2, head(etitanic), type = "prob")


summary(a1, digits = 2, style = "pmax")

summary(a2, digits = 2, style = "pmax")




# Variable importance in MARS: MARS models include a backwards elimination feature selection 
# routine that looks at reductions in the generalized cross-validation (GCV) estimate of error.
# The varImp function tracks the changes in model statistics, such as the GCV, for each predictor 
# and accumulates the reduction in the statistic when each predictor's feature is added to the model.


#############
# References
#############

# http://www.inside-r.org/packages/cran/earth/docs/earth
# https://en.wikipedia.org/wiki/Multivariate_adaptive_regression_splines
# http://www.statsoft.com/Textbook/Multivariate-Adaptive-Regression-Splines
# http://www.salford-systems.com/products/mars
# http://stackoverflow.com/questions/22119934/response-prediciton-with-earth-mars-and-caret-in-r
# https://www.kaggle.com/c/overfitting/forums/t/456/modelling-algorithms-in-r
# https://qizeresearch.wordpress.com/2013/12/04/a-short-example-of-multivariate-adaptive-regression-splines-mars/
# http://machinelearningmastery.com/non-linear-regression-in-r/  
# http://victorwyee.com/r/exercise-implementing-mars-model-r/  
# http://finzi.psych.upenn.edu/library/earth/html/format.earth.html
# http://artax.karlin.mff.cuni.cz/r-help/library/caret/html/varImp.html
# https://qizeresearch.wordpress.com/2013/12/04/a-short-example-of-multivariate-adaptive-regression-splines-mars/