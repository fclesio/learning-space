# Check if the package already exists 
list.of.packages <- c("forecast", "xts")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Load the lib
library(forecast)
library(xts)

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

#Decomposition
decomp_ts_npl <- stl(ts_npl, s.window="period")
plot(decomp_ts_npl)

# simple exponential - models level
holt_model <- HoltWinters(ts_train, beta=FALSE, gamma=FALSE)

# double exponential - models level and trend
holt_model_trend <- HoltWinters(ts_train, gamma=FALSE)

# triple exponential - models level, trend, and seasonal components
holt_model_trend_seasonal <- HoltWinters(ts_train)

# predict in 12 steps ahead
plot(forecast(holt_model, 12))

plot(forecast(holt_model_trend, 12))

plot(forecast(holt_model_trend_seasonal, 12))


