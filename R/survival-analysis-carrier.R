nm <- read.csv("http://www.sgi.com/tech/mlc/db/churn.names", 
               skip=4, colClasses=c("character", "NULL"), header=FALSE, sep=":")[[1]]

##Original Link: http://stackoverflow.com/questions/27080207/survival-analysis-for-telecom-churn-using-r


##Get info from CSV file online
dat <- read.csv("http://www.sgi.com/tech/mlc/db/churn.data", header=FALSE, col.names=c(nm, "Churn"))

##Load splines library. More info: https://stat.ethz.ch/R-manual/R-devel/library/splines/html/splines-package.html 
library(splines)

##Load survival library. More info: https://cran.r-project.org/web/packages/survival/index.html
library(survival)

##Object Modeling
s <- with(dat, Surv(account.length, as.numeric(Churn)))

##Fit a cox proportional hazards model
model <- coxph(s ~ total.day.charge + number.customer.service.calls, data=dat[, -4])
summary(model)

##Plot results
plot(survfit(model))

##Add Stratum
model <- coxph(s ~ total.day.charge + strata(number.customer.service.calls <= 3), data=dat[, -4])
summary(model)

##Plot final result
plot(survfit(model), col=c("blue", "red"))


