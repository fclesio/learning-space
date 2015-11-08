install.packages("ggplot2")
install.packages("ggsurv")
install.packages("survival")

#Load Survival package
library(survival)

#Read CSV file
sorte_506 <- read.csv('/Users/flavioclesio/Documents/Github/learning-space/survival_analysis_5_506.csv')

#Check header
head(sorte_506)

#Basic statistics
summary(sorte_506)

#Apply the survival function, using survival days (diff between active date and cancelled date, and the variable churned)
sorte_506$survival <- Surv(sorte_506$survival_days, sorte_506$churned == 1)

#Fit the function
fit <- survfit(survival ~ 1, data = sorte_506)

#Plot the survival basic funcion
plot(fit, lty = 1, mark.time = TRUE
     , xlim=c(1,90)
     , ylim=c(.00,1)
     , xlab = '# Days of subscription'
     , ylab = '% Retention Subscribers')

title(main = 'Basic Retention Curve of Sorte')

#For now we'll check some variables that make the churn rise!
#To do this will use Kaplan-Meier Estimator (https://en.wikipedia.org/wiki/Kaplan%E2%80%93Meier_estimator)
#We'll use this approach 'cause lot of our data is right-censored, i.e.
#if we don't have the event of churn (failure/death) we'll assume that the subscription is active
# The formula is: \hat S(t) = \prod\limits_{t_i<t} \frac{n_i-d_i}{n_i}.



#We'll use 3 variables to the first analysis: has_billed, user_plan, renew_count
#We'll use the same dataframe and same survival function

#Read CSV file
sorte_506 <- read.csv('/Users/flavioclesio/Documents/Github/learning-space/survival_analysis_5_506.csv')

#Check header
head(sorte_506)

##Check variables
names(sorte_506)

##Check variables data types
str(sorte_506)

#Calls function
sorte_506$survival <- Surv(sorte_506$survival_days, sorte_506$churned == 1)

######################################################
#Fit the survival function using variable has_billed
######################################################
fit_has_billed <- survfit(survival ~ has_billed, data = sorte_506)

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

title(main = "Sorte Survival Curves by Billing")

abline(v=(seq(0,180,7)), col="gray", lty="dotted")
abline(h=(seq(0,1,.10)), col="gray", lty="dotted")



#Log-Rank Test
survdiff(survival ~ has_billed, data = sorte_506)


######################################################
#Fit the survival function using variable user_plan
######################################################
fit_user_plan <- survfit(survival ~ user_plan, data = sorte_506)

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

title(main = "Sorte Survival Curves by User Plan")

abline(v=(seq(0,180,7)), col="gray", lty="dotted")
abline(h=(seq(0,1,.10)), col="gray", lty="dotted")


#Log-Rank Test
survdiff(survival ~ user_plan, data = sorte_506)



#References
#http://daynebatten.com/2015/02/customer-churn-survival-analysis/
#http://daynebatten.com/2015/02/customer-churn-cox-regression/

