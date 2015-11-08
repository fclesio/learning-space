# Um dos maiores desafios em serviços de assinaturas é manter a 
# recorrencia do fluxo de receita, isso é, um modelo de gestão [1], [2] 
# de assunaturas passa obrigatóriamente pelo fato de que a retenção dos
# clientes é o aspecto mais importante de toda a cadeia de receita.
# 
# No entanto quando essa cadeia é quebrada, isso significa que o cliente
# saiu por N motivos, e assim fica caracterizado o churn. 
# 
# Neste caso vamos usar Survival Analysis [3] para realizar uma estimativa
# do tempo em que o usuário fica na base até o evento de churn (falha/morte)

# Na análise usaremos o estimador Kaplan-Meier [4] para estimar o tempo
# de vida da assinatura, dado que teremos censura à direita. 
# 
# Em outras palavras vamos estimar dado um deteminado período sem saber
# ao certo o plano de futuro que iremos ter até o que o cliente venha a
# sair da base.






#Load survival package
library(survival)

#Read the original dataset on the web
nm <- read.csv("http://www.sgi.com/tech/mlc/db/churn.names", 
               skip=4, colClasses=c("character", "NULL"), header=FALSE, sep=":")[[1]]


#Read the header
dat <- read.csv("http://www.sgi.com/tech/mlc/db/churn.data", header=FALSE, col.names=c(nm, "Churn"))

#Apply the survival function of the duration of the account
s <- with(dat, Surv(account.length, as.numeric(Churn)))


##Calculate cox proportional hazards model and plot the result
model <- coxph(s ~ total.day.charge + number.customer.service.calls, data=dat[, -4])

#Information about the model
summary(model)

#Plot the results
plot(survfit(model))


model <- coxph(s ~ total.day.charge + strata(number.customer.service.calls <= 3), data=dat[, -4])

summary(model)

plot(survfit(model), col=c("blue", "red"))



## Reference [1]: http://stackoverflow.com/questions/27080207/survival-analysis-for-telecom-churn-using-r
## Reference [2]: http://daynebatten.com/2015/02/customer-churn-survival-analysis/
## Reference [3]: https://en.wikipedia.org/wiki/Survival_analysis
## Reference [4]: https://en.wikipedia.org/wiki/Kaplan%E2%80%93Meier_estimator
## Reference [5]: 
## Reference [6]: 
## Reference [7]: 