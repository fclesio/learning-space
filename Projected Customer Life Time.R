
#Install support packages
install.packages('DAAG')
install.packages('survival')

#Load Survival package
library(survival)
library(DAAG)

#Read CSV file
sorte_506 <- read.csv('/Users/flavioclesio/Documents/Github/learning-space/survival_analysis_5_506.csv')

#As we have not observed censoring in the subscriptions that was not cancelled, we'll put 500 as default value
sorte_506$survival_days <- as.integer(sorte_506$survival_days)
sorte_506$survival_days[is.na(sorte_506$survival_days)]<- 500 #Must be more than the max value of serie

sorte_506$churned <- as.integer(sorte_506$churned)
sorte_506$churned[is.na(sorte_506$churned)]<- 1


#Rapid disclaimer: As we noted after the run the script, we have a HUGE bias in the absense 
# of cancelled subscriptions, 'cause after 30 days every cancelled subscription has taken off the main table. 
# To overcome this, all cancelled_subscriptions must be put in the dataset.

#Check header
head(sorte_506)

#Basic statistics
summary(sorte_506)

#Apply the survival function, using survival days (diff between active date and cancelled date, and the variable churned)
sorte_506$survival <- Surv(sorte_506$survival_days, sorte_506$churned == 1)

#Fit the function
fit <- survfit(survival ~ 1, data = sorte_506)

#Mean
curve <- fit[['surv']] 

# Build an X variable (number of days), then fit a model
days <- as.numeric(length(curve))

#Put Days
x_var <- (1:days)

#Linear Modeling
model_fit <- lm(log(curve) ~ x_var)

#Check Stats
summary(model_fit)
summary(model_fit)$coefficients[,4] 
summary(model_fit)$r.squared
coefficients(model_fit)
confint(model_fit, level=0.95) # CIs for model parameters 
fitted(model_fit) # predicted values
residuals(model_fit) # residuals
anova(model_fit) # anova table 
vcov(model_fit) # covariance matrix for model parameters 
influence(model_fit) # regression diagnostics

# diagnostic plots 
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(model_fit)

#Insert the model of the equation
eq <- function(x) {exp(model_fit[['coefficients']][1] + model_fit[['coefficients']][2] * x)}


plot(x = x_var
     , y = curve
     , type = 'l'
     , col = 'red'
#     , xlim = c(1, 365) #Projection in Days
     , xlim = c(1, days + 7000)
     , ylim = c(0, 1)
     , xlab = '# Days of subscription'
     , ylab = '% Curve of Decay'
     , xaxt='n'
     , yaxt='n'
     ,lwd=c(2.5,2.5)     
     )

curve(eq, add = TRUE, col = 'blue', lwd=(1), lty=2)

title(main='Projected Sorte Survival Curve', font.main=4)

legend(x = 200
       , y = .5
       , legend = c('Actual', 'Projected')
       , col = c('red', 'blue')
       ,lty = 1)

# Calculate mean lifetime
integrate(eq, 0, Inf)


##Formating Axes
axis(side=1, at=seq(0, 8000, by=100))
axis(side=2, at=seq(0, 1, by=.10), labels=paste(seq(0,100,10), "%", sep=""), las=TRUE)

abline(v=(seq(0,8000,1000)), col="gray", lty="dotted")
abline(h=(seq(0,1,.10)), col="gray", lty="dotted")

