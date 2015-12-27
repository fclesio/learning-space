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




# Load Survival package
library(survival)

# Load splines library.
library(splines)



#Read CSV file
telco_subs <- read.csv('https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/telco_subscriptions.csv')

#Check header
head(telco_subs)

#Basic statistics
summary(telco_subs)







#Apply the survival function, using survival days (diff between active date and cancelled date, and the variable churned)
telco_subs$survival <- Surv(telco_subs$survival_days, telco_subs$churned == 1)

#Fit the function
fit <- survfit(survival ~ 1, data = telco_subs)

# Info about the model 
summary(fit)

#Plot the survival basic funcion
plot(fit, lty = 1, mark.time = TRUE
     , xlim=c(1,90)
     , ylim=c(.00,1)
     , xlab = '# Days of subscription'
     , ylab = '% Retention Subscribers'
     , yaxt="n"
     , main='Basic Retention Curve of Telco Subscriptions'
) 
axis(2, at=pretty(fit$surv), lab=paste0(pretty(fit$surv) * 100, " %"), las=TRUE)



#For now we'll check some variables that make the churn rise!
#To do this will use Kaplan-Meier Estimator (https://en.wikipedia.org/wiki/Kaplan%E2%80%93Meier_estimator)
#We'll use this approach 'cause lot of our data is right-censored, i.e.
#if we don't have the event of churn (failure/death) we'll assume that the subscription is active
# The formula is: \hat S(t) = \prod\limits_{t_i<t} \frac{n_i-d_i}{n_i}.

#We'll use 3 variables to the first analysis: has_billed, user_plan, renew_count
#We'll use the same dataframe and same survival function

#Read CSV file
telco_subs <- read.csv('https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/telco_subscriptions.csv')

#Check header
head(telco_subs)

##Check variables
names(telco_subs)

##Check variables data types
str(telco_subs)

#Calls function
telco_subs$survival <- Surv(telco_subs$survival_days, telco_subs$churned == 1)

#Fit the survival function using variable has_billed
fit_has_billed <- survfit(survival ~ has_billed, data = telco_subs)

#Plotting the variable has_billed
plot(fit_has_billed
     , lty = 1:2
     , mark.time = FALSE
     , xlim=c(1,180)
     , ylim=c(.00,1)
     , xaxt='n'
     , yaxt='n'
     , xlab = '# Days since Subscribing'
     , ylab = '% Retention Subscribers'
     , col=c("blue","red")
     ,lwd=c(2.5,2.5)
     )

legend(130,1
       , c("Billed","Not_Billed")
       , lty=c(1,2)
       , cex=1
       , bty = 'y'
       , col=c("blue","red")
       , lwd=c(2.5,2.5)
       , horiz=FALSE)


##Formating Axes
axis(side=1, at=seq(0, 180, by=14))
axis(side=2, at=seq(0, 1, by=.10), labels=paste(seq(0,100,10), "%", sep=""), las=TRUE)

title(main = "Survival Curves in Telcom Subscriptions by Billing")

# Grid Lines
abline(v=(seq(0,180,7)), col="gray", lty="dotted")
abline(h=(seq(0,1,.10)), col="gray", lty="dotted")



#Log-Rank Test
survdiff(survival ~ has_billed, data = telco_subs)


#Fit the survival function using variable user_plan
fit_user_plan <- survfit(survival ~ user_plan, data = telco_subs)

#Plotting the variable has_billed
plot(fit_user_plan
     , lty = 1:2
     , mark.time = FALSE
     , xlim=c(1,180)
     , ylim=c(.00,1)
     , xaxt='n'
     , yaxt='n'
     , xlab = '# Days since Subscribing'
     , ylab = '% Retention Subscribers'
     , col=c("blue","red", "black")
     ,lwd=c(2.5,2.5,2.5)
)

legend(130,1
       , c("Post-paid","Pre-paid","Unknown")
       , lty=c(1,2)
       , cex=1
       , bty = 'y'
       , col=c("blue","red","black")
       , lwd=c(2.5,2.5,2.5)
       , horiz=FALSE)


##Formating Axes
axis(side=1, at=seq(0, 180, by=14))
axis(side=2, at=seq(0, 1, by=.10), labels=paste(seq(0,100,10), "%", sep=""), las=TRUE)

title(main = "Survival Curves in Telcom Subscriptions by User Plan")

abline(v=(seq(0,180,7)), col="gray", lty="dotted")
abline(h=(seq(0,1,.10)), col="gray", lty="dotted")


#Log-Rank Test
survdiff(survival ~ user_plan, data = telco_subs)



s <- with(telco_subs, Surv(telco_subs$survival_days, telco_subs$churned))

##Fit a cox proportional hazards model
model <- coxph(s ~ telco_subs$created_as_free_user + telco_subs$has_billed + telco_subs$user_plan + telco_subs$billing_count , data=telco_subs)

summary(model)

##Plot final result
plot(survfit(model), col=c("blue", "red"))

# References
# http://daynebatten.com/2015/02/customer-churn-survival-analysis/
# http://daynebatten.com/2015/02/customer-churn-cox-regression/
# http://stackoverflow.com/questions/27080207/survival-analysis-for-telecom-churn-using-r
## Reference [1]: http://stackoverflow.com/questions/27080207/survival-analysis-for-telecom-churn-using-r
## Reference [2]: http://daynebatten.com/2015/02/customer-churn-survival-analysis/
## Reference [3]: https://en.wikipedia.org/wiki/Survival_analysis
## Reference [4]: https://en.wikipedia.org/wiki/Kaplan%E2%80%93Meier_estimator


