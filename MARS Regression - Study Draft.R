# load the package
library(earth)
# load data
data(longley)
# fit model
fit <- earth(Employed~., longley)
# summarize the fit
summary(fit)
# summarize the importance of input variables
evimp(fit)
# make predictions
predictions <- predict(fit, longley)
# summarize accuracy
rmse <- mean((longley$Employed - predictions)^2)
print(rmse)


longley

install.packages("earth")

a <- earth(Volume ~ ., data = trees)
plotmo(a)
summary(a, digits = 2, style = "pmax")




install.packages("caret")


library(earth)
library(caret)

data(etitanic)

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





References

http://www.inside-r.org/packages/cran/earth/docs/earth

https://en.wikipedia.org/wiki/Multivariate_adaptive_regression_splines

http://www.statsoft.com/Textbook/Multivariate-Adaptive-Regression-Splines

http://www.salford-systems.com/products/mars

