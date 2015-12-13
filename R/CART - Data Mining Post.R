
# Instalacao dos pacotes
install.packages("rpart")
install.packages("party")
install.packages("rpart.plot")

# Carga das bibliotecas usadas na analise
library(rpart)
library(party)
library(rpart.plot)

# Load dos dados direto do github
credit_dirty <- read.csv("https://raw.githubusercontent.com/fclesio/learning-space/Change_Dataset/Datasets/credit_dirty.csv")

# Checagem para ver se o arquivo foi importado com sucesso
head(credit_dirty)

# Estatisticas basicas
summary(credit_dirty)

# Geracao de arvore basica com todos os campos
fitCART <- rpart(class ~ checking_status + duration + credit_history 
                 + purpose + credit_amount + savings_status 
                 + employment + installment_commitment + personal_status 
                 + other_parties + residence_since + property_magnitude 
                 + age + other_payment_plans + housing 
                 + existing_credits + job + num_dependents 
                 + own_telephone + foreign_worker,
             method="class", data=credit_dirty)


# No caso, como estamos em um problema tipico de classificacao, estamos usando o method="class". 
# Se estivessemos em um problema de regressao, usariamos o method="anova".

# Verificacao inicial do modelo 
printcp(fitCART)

#Visualizacao dos resultados provenientes de Cross-Validation
plotcp(fitCART) 

# Sumario completo do modelo
summary(fitCART)

# Coeficiente de determinacao aproximado e o erro relativo para cada divisao na arvore
rsq.rpart(fitCART)

# Plotagem da arvore
plot(fitCART
     ,uniform=TRUE
     ,main="Arvore de Classificacao para Credit")
text(fitCART
     ,use.n=TRUE
     ,all=TRUE
     ,cex=.8)

# Nesse snippet observamos o os parametros associados ao menor erro de Cross-Validation. 
# Esse parametro sera usado na funcao de prunning para determinar o melhor conjunto de 
# atributos que evitam o overfitting do modelo 

fitCART$cptable[which.min(fitCART$cptable[,"xerror"]),"CP"]

# Com o resultado acima, realizamos o prunning de acordo com a menor complexidade e menor overfitting
prune(fitCART, cp= 0.01833333)

# Geracao da arvore com com prunning
prunnedCART <- prune(fitCART
                     ,cp= 0.01833333
                     ,fitCART$cptable[which.min(fitCART$cptable[,"xerror"]),"CP"])


# Como as arvores estao extremamente ruins de visualizar, 
# vamos usar a bibliotera do prp para melhorar isso

# No entanto, como ja temos framework de visualizacao de arvores, 
# vamos optar por fazer uma funcao para manter um padrao de visualizacao, dado que 
# os parametros sempre sao os mesmos. No caso vamos construir uma wrapper function.

wrappertree <- function(x
                        ,extra=100
                        ,uniform=T
                        ,type = 4
                        ,under=F
                        ,branch=1
                        ,yesno=T
                        ,leaf.round=1
                        ,border.col=1
                        ,xsep="/"
                        ,xcompact=TRUE
                        ,ycompact=TRUE
                        ,nn=TRUE
                        )
  {
    prp(x=x
        ,extra=extra
        ,uniform=uniform
        ,type=type
        ,under=under
        ,branch=branch
        ,yesno=yesno
        ,leaf.round=leaf.round
        ,border.col=border.col
        ,xsep=xsep
        ,xcompact=xcompact
        ,ycompact=ycompact
        ,nn=nn)
  }


# Arvore construida com funcao wrapper com os dados do modelo completo
wrappertree (fitCART)

# Arvore construida com funcao wrapper com os dados do modelo ja podado
wrappertree (prunnedCART)

# Funcao para emular heatmap
heat.tree <- function(tree, low.is.green=FALSE, ...) {
  y <- tree$frame$yval
  if(low.is.green)
    y <- -y
  max <- max(y)
  min <- min(y)
  cols <- rainbow(99, end=.36)[
    ifelse(y > y[1], (y-y[1]) * (99-50) / (max-y[1]) + 50,
           (y-min) * (50-1) / (y[1]-min) + 1)]
  prp(tree, branch.col=cols, box.col=cols, ...)
}


# Funcao para split das arvores
split.fun <- function(x, labs, digits, varlen, faclen)
{
  labs <- gsub(",", " ", labs)
  for(i in 1:length(labs)) {
    labs[i] <- paste(strwrap(labs[i], width=25), collapse="\n")
  }
  labs
}

# Arvore em forma de heatmap
heat.tree(fitCART, type=4, extra=100, varlen=0, faclen=0, fallen.leaves=TRUE, split.fun=split.fun)

# Arvore em forma de heatmap
heat.tree(prunnedCART, type=4, extra=100, varlen=0, faclen=0, fallen.leaves=TRUE, split.fun=split.fun)



#Agora vamos usar CART para um problema de regressao

# Load dos dados direto do github
imoveis_tambore_barueri <- read.csv("https://raw.githubusercontent.com/fclesio/learning-space/c3a4c44f0cec655b3cb5fabfa45cd574e4436d9e/Datasets/imoveis-tambore-parnaiba-2013.csv", header=TRUE)

# Checagem para ver se o arquivo foi importado com sucesso
head(imoveis_tambore_barueri)

# Estatisticas basicas
summary(imoveis_tambore_barueri)

# Checagem das variaveis
str(imoveis_tambore_barueri)


# Geracao de arvore basica com todos os campos
fitCART <- rpart(ValorVenda ~ Entrada + Condominio + ValorM2  + 
                   QtdeDormitorios + Suite + Vagas + AreaUtil + 
                   ConstruidoEm + Andares + Churrasqueira + AreaServico + 
                   Playground + Ginastica + SalaJogos + Piscina + 
                   QuadraPoliesportiva + SalaFestas,
                 method="anova", data=imoveis_tambore_barueri)



fitCART$cptable[which.min(fitCART$cptable[,"xerror"]),"CP"]

# Com o resultado acima, realizamos o prunning de acordo com a menor complexidade e menor overfitting
prune(fitCART, cp= 0.01)

# Geracao da arvore com com prunning
prunnedCART <- prune(fitCART
                     ,cp= 0.01
                     ,fitCART$cptable[which.min(fitCART$cptable[,"xerror"]),"CP"])



prp(prunnedCART
  ,extra=100
  ,uniform=T
  ,type = 4
  ,under=F
  ,branch=1
  ,yesno=T
  ,leaf.round=1
  ,border.col=1
  ,xsep="/"
  ,xcompact=TRUE
  ,ycompact=TRUE
  ,nn=TRUE
  , main="CART para a arvore podada")

#Not working
predictions <- predict(prunnedCART, imoveis_tambore_barueri[,1:18])
rmse <- mean((imoveis_tambore_barueri$ValorVenda - predictions)^2)
print(rmse)

#------------
# References
#------------

# 1 - http://statweb.stanford.edu/~lpekelis/talks/13_datafest_cart_talk.pdf
# 2 - http://www.statmethods.net/advstats/cart.html
# 3 - http://www.milbo.org/rpart-plot/prp.pdf
# 4 - http://www.r-bloggers.com/a-brief-tour-of-the-trees-and-forests/

