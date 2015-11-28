#Decision Trees Draft Study 

#Install Packages
install.packages("C50")
install.packages("rpart")
install.packages("rpart.plot") 


# Load packages
library(C50)
library(rpart)
library(rpart.plot) 

# Dataset
data(churn)

#Variables
Variables      <-c(4,7,16,19,17,20)               

# Training Set
Entrenamiento  <-churnTrain[,Variables]

# Test Set
Test           <-churnTest [,Variables]


#Decision Tree
ModeloArbol <- rpart(churn ~ .
                     ,data=Entrenamiento
                     ,parms=list(split="information"))


# Test prediction using test set
Prediccion <- predict(ModeloArbol
                      ,Test
                      ,type="class")

# Confusion Matrix
MC <- table(Test[, "churn"]
            ,Prediccion)


# Plot Graph
rpart.plot(ModeloArbol
           ,type=1
           ,extra=100
           ,cex = .7,
           box.col=c("gray99", "gray88")[ModeloArbol$frame$yval])




# References

# http://apuntes-r.blogspot.com.br/2014/09/predecir-perdida-de-clientes-con-arbol.html