# Check if the package already exists 
list.of.packages <- c("forecast")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Load the lib
library(forecast)

# Load dataset of delinquency rate in Brazil (Data from BACEN - Brazilian Central Bank)
non_performing_loans <- read.csv('https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/08%20-%20Time%20Series/inadimplencia_non_performing_loans_individuals.csv')

# We can see the timespan of our series
non_performing_loans

# Transform in Date
non_performing_loans$month <- as.Date(non_performing_loans$month, "%m/%d/%Y") 

# As a want to made some holdout testing, I'll split the dataset in two, always respecting 
# the original series order.

# First at all I'll take the number of rows in my series (n = 65)
n = nrow(non_performing_loans)

# After that I'll take 70% of the serie in a variable to made the split using index (n_70 = 45)
n_70 = as.integer(n*0.7) 

# Using index I'll have the first 45 data points (start = "2011-03-01", end = "2014-11-01")
non_performing_loans$month[1:n_70] 

# Using this index index we'll have last 20 datapoints (start = "2014-12-01", end = "2016-07-01")
non_performing_loans$month[(n_70+1):n]

# Following the same logic let's create our time series objects
percent_70_train <- non_performing_loans$percent[1:n_70] 
percent_30_test <- non_performing_loans$percent[(n_70+1):n]

# Transformation in time-series object
ts_train <- ts(percent_70_train, start=c(2011, 3), end=c(2014, 11), frequency=12) 
ts_test <- ts(percent_30_test, start=c(2014, 12), end=c(2016, 7), frequency=12) 

# As we can see, our series begins in March of 2011 and ends at July of 2016.
# Let's transform this in an time series object 
ts_npl <- ts(non_performing_loans$percent, start=c(2011, 3), end=c(2016, 7), frequency=12) 
       
# Some stats and PLOT! (To not to break the habit)
summary(ts_npl)

# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 3.650   4.030   4.290   4.505   5.030   5.500 

# PLotting
plot(ts_npl, type="l", xlab="Year", ylab="% Delinquency")
# We had a huge drop between 2012 and 2015, and after that we are watching some bouncing

# Now we'll use Auto Arima function to predict based in our training set 
npl_model_train <- auto.arima(ts_train)

# Some stats about the model
summary(npl_model_train)

# Series: ts_train 
# ARIMA(0,2,2)(0,1,0)[12]                    
# 
# Coefficients:
#   ma1     ma2
# -0.9255  0.4491
# s.e.   0.1562  0.1453
# 
# sigma^2 estimated as 0.006275:  log likelihood=32.38
# AIC=-58.75   AICc=-57.86   BIC=-54.45
# 
# Training set error measures:
#   ME       RMSE        MAE        MPE      MAPE       MASE       ACF1
# Training set 0.002734132 0.06359177 0.04264805 0.08402133 0.9485358 0.06858605 -0.0705292

# We'll use full data right now for baseline
npl_model <- auto.arima(ts_npl)


# Let's store this models in two objects
y <- npl_model_train

z <- npl_model


# Some ajustments in confidence intervals
forecast(y, level=c(80, 95, 99), h=20)

# We'll store this prediction in some object
fore_y <- forecast(y, level=c(80, 95, 99), h=20)

# Averages of predictons
fore_y$mean

# Dates objects for posterior ploting
dates <- seq(as.Date("01/12/2014", format = "%d/%m/%Y"),by = "month", length = length(ts_test))

# Comparison between predicted and realized
plot(dates,fore_y$mean, col="red", type='l', lty=2, lwd=3,ylab="% Deliquency", xlab="Year")
par(new=TRUE)
plot(ts_test, col="grey", lwd=3,xaxt='n', yaxt='n', ann=FALSE)  
legend("topleft", 9.5, c("Predicted","Realized"),lty=c(2,1),lwd=c(2.5,2.5),col=c("red","grey"))


# Holdout testing. We'll create new object to simplify the code.
# Holdout sample that we'll use for test
realized <- ts_test 

# Mean of all predictions
forecasting <- fore_y$mean

# Date series
month_year <- non_performing_loans$month[(n_70+1):n]

# Binding the values in a single table
realized_forecasting <- cbind(month_year,realized,forecasting,forecasting-realized)

# Ajustments in some columns
colnames(realized_forecasting) <- c("date","realized","forecast", "Difference")

# New dataframe
forecast_series <- as.data.frame(realized_forecasting)

# Some cosmetics in date
forecast_series$date <- as.Date(forecast_series$date)

# Serie of difference between realized and forecasting
forecast_series$Difference

# Some stats to see the dispersion in the difference series
w <- mean(forecast_series$Difference)
x <- sd(forecast_series$Difference)

sprintf("The avg of differences was: %s and the std was: %s", w, x)
# "The avg of differences was: 0.256055162656973 and the std was: 0.223174375574195"

# Forecasting
plot(forecast(fore_y))  
