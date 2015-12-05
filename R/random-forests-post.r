
# Instalacao dos pacotes
install.packages("randomForest")

# Random Forest usado na predicao de valores do tipo categoricos no R (factors)
library(randomForest)

fit <- randomForest(Kyphosis ~ Age + Number + Start,   data=kyphosis, importance=TRUE,
                    proximity=TRUE, ntree=100)

# Resultados do modelo
print(fit)

# Importancia de cada variavel
round(importance(fit), 2)

varImpPlot(fit)

# Importancia de cada variavel de predicao
layout(matrix(c(1,2),nrow=1),
       width=c(4,1)) 
plot(fit, log="y")
plot(c(0,1),type="n", axes=F, xlab="", ylab="")
legend("top", colnames(fit$err.rate),col=1:4,cex=0.8,fill=1:4)

MDSplot(fit, kyphosis$Kyphosis)

getTree(fit,labelVar=TRUE)

# Previsoes com o modelo 
predictions <- predict(fit, kyphosis[,2:4])

# Acuracia do modelo 
rmse <- mean((kyphosis$Kyphosis - predictions)^2)
print(rmse)




# Referencias

# 1 - http://www.statmethods.net/advstats/cart.html
# 2 - https://cran.r-project.org/web/packages/randomForest/randomForest.pdf
# 3 - http://stackoverflow.com/questions/14996619/random-forest-output-interpretation
