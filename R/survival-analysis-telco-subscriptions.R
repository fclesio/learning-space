# One of the biggest challenges is to keep the subscriptions services is the recurring of the revenue stream.
# It means a management model of subscriptions where retention of the customers is the most important aspect 
# of the entire revenue.

# However when this chain is broken, it means that the client out of the service for no reason, 
# and it's called Churn.

# In this case let's use Survival Analysis to estimate the time when the user is at the base until
# the event of churn (failure/death)

# The first analysis will use the Kaplan-Meier estimator to estimate the time signature lifetime, 
# given that we have censorship on the right.

# The second one will use cox proportional hazards model to see the importance of each variable in churn. 

# In other words vet's estimate given a determined period without knowing the future if the customer will leave
# and the main aspects of our dataset that can help to explain this. 

# Load Survival package
library(survival)

#Read CSV file
telco_subs <- read.csv('https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/telco_subscriptions.csv')

#Check header
head(telco_subs)

#Basic statistics
summary(telco_subs)

##Check variables
names(telco_subs)

##Check variables data types
str(telco_subs)





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





# Let's use the Cox Hazard Model  
cox_subs <- with(telco_subs, Surv(telco_subs$survival_days, telco_subs$churned))

# Fitting the model using the variables created_as_free_user, has_billed, user_plan, billing_count 
fit_cox_subs <- coxph(cox_subs ~ telco_subs$created_as_free_user + telco_subs$has_billed + telco_subs$user_plan + telco_subs$billing_count, data=telco_subs)

# Get info about the model 
summary(fit_cox_subs)

# Plotting the model 
plot(survfit(fit_cox_subs)
     , mark.time = FALSE
     , xlim=c(1,180) # I censored in 180 days, 'cause this is where the survival curve convenges to zero
     , ylim=c(.00,1)
     , xaxt='n'
     , yaxt='n'
     , xlab = '# Days since Subscribing'
     , ylab = '% Retention Subscribers'
  )

# Format axis
axis(side=1, at=seq(0, 180, by=14))
axis(side=2, at=seq(0, 1, by=.10), labels=paste(seq(0,100,10), "%", sep=""), las=TRUE)

title(main = "Survival Curves in Telcom Subscriptions")

abline(v=(seq(0,180,7)), col="black", lty="dotted")
abline(h=(seq(0,1,.10)), col="black", lty="dotted")





#############
# References
#############

# [1]: http://stackoverflow.com/questions/27080207/survival-analysis-for-telecom-churn-using-r
# [2]: http://daynebatten.com/2015/02/customer-churn-survival-analysis/
# [3]: https://en.wikipedia.org/wiki/Survival_analysis
# [4]: https://en.wikipedia.org/wiki/Kaplan%E2%80%93Meier_estimator
# [5]: http://daynebatten.com/2015/02/customer-churn-survival-analysis/
# [6]: http://daynebatten.com/2015/02/customer-churn-cox-regression/
# [7]: http://stackoverflow.com/questions/27080207/survival-analysis-for-telecom-churn-using-r