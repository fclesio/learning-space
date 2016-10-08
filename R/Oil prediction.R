# Load packages
library(forecast)
library(TTR)

# Get data
oil_production <- read.csv('https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/oil_production_2000_2015.csv')

# Transform data in timeseries object
ts_production <- ts(oil_production$Value, frequency = 365, start=c(2001,1))

# Check variables data types
str(ts_production)

# Basic statistics
summary(ts_production)

# Basic Histogram
qplot(ts_production)

# Plot the series 
plot(ts_production
     , main = 'Oil Production in Petrostate'
     , xlab='Year'
     , ylab='# Crude Oil Barrels')

# We wll use some log scale to see some outliers (not a big deal!)
log_ts_production <- log(ts_production)

plot.ts(log_ts_production
        , main = 'Oil Production in Petrostate'
        , xlab = 'Year'
        , ylab = '# Crude Oil Barrels (Log)'
        )

# Let's see some discrepancies using Moving Average to see in cristal clear some trends considering some time intervals
sma_30_ts_production <- SMA(ts_production,n=30)
sma_30_ts_production <- ts(sma_30_ts_production, start = c(2001, 1), frequency = 365) 

sma_90_ts_production <- SMA(ts_production,n=90)
sma_90_ts_production <- ts(sma_90_ts_production, start = c(2001, 1), frequency = 365) 

sma_180_ts_production <- SMA(ts_production,n=180)
sma_180_ts_production <- ts(sma_180_ts_production, start = c(2001, 1), frequency = 365) 

sma_360_ts_production <- SMA(ts_production,n=360)
sma_360_ts_production <- ts(sma_360_ts_production, start = c(2001, 1), frequency = 365) 

sma_1080_ts_production <- SMA(ts_production,n=1080)
sma_1080_ts_production <- ts(sma_1080_ts_production, start = c(2001, 1), frequency = 365) 


# Plot SMA's
par(mfrow=c(2,3))
plot.ts(sma_30_ts_production, main="Crude Oil Production \n SMA in 30 Days", ylab="# Barrels Crude Oil", xlab="Year")
plot.ts(sma_90_ts_production, main="Crude Oil Production \n SMA in 90 Days", ylab="# Barrels Crude Oil", xlab="Year")
plot.ts(sma_180_ts_production, main="Crude Oil Production \n SMA in 180 Days", ylab="# Barrels Crude Oil", xlab="Year")
plot.ts(sma_360_ts_production, main="Crude Oil Production \n SMA in 360 Days", ylab="# Barrels Crude Oil", xlab="Year")
plot.ts(sma_1080_ts_production, main="Crude Oil Production \n SMA in 1080 Days", ylab="# Barrels Crude Oil", xlab="Year")



#Decompose seasonality 
decom_ts_production <- decompose(ts_production)

plot(decom_ts_production)



# Get values of decompositions
decom_ts_production$x         # Observed
decom_ts_production$trend     # Trend
decom_ts_production$seasonal  # Seasonal component
decom_ts_production$random    # Random component



# Ok, but we need to do a seasonal ajustment to clean our data and bring only the performance over the years
decom_ts_production <- decompose(ts_production)

decom_ts_production_ajusted <- ts_production - decom_ts_production$seasonal

plot(decom_ts_production_ajusted
     , main = 'Production of Crude Oil \n Remove Seasonal Component'
     , xlab = 'Year'
     , ylab = '# Crude Oil Barrels Production'
     )



# But we need to dig more dipper. True performance not deal with random appereances. Let's remove that 
decom_ts_production_ajusted_less_random_seasonal <- (ts_production - decom_ts_production$seasonal)- decom_ts_production$random

plot(decom_ts_production_ajusted_less_random_seasonal
     , main = 'Production of Crude Oil \n  No Seasonal and Random Comp.'
     , xlab = 'Year'
     , ylab = '# Crude Oil Barrels Production'
)
     



# This time, we need release only the random component, to get all seasonality and all variations
decom_ts_production_ajusted_less_random <- (ts_production - decom_ts_production$random)

plot(decom_ts_production_ajusted_less_random
     , main = 'Production of Crude Oil \n  Remove Random Component'
     , xlab = 'Year'
     , ylab = '# Crude Oil Barrels Production'
     )



# A STL Model get the following elements of a time series: trend, seasonal, and irregular. [3]
stl_ts_production <- stl(ts_production, s.window = "periodic")

plot(stl_ts_production, main = 'Decomposition of Crude Oil Prodution Series')





# This time we'll using Holt Winters modeling [4] 

# Simple exponential - models level
fit_simple_ts_production <- HoltWinters(ts_production, beta=FALSE, gamma=FALSE)

accuracy(forecast(fit_simple_ts_production, 180)) # Predictive Accuracy

plot(fit_simple_ts_production)

plot(forecast(fit_simple_ts_production, 180))
legend('topleft'
       ,c('Actual', 'Forecast', 'Error Bounds (95% Confidence)')
       ,lty=c(1,1,1)
       ,col=c(1,4,240))

# Double exponential - models level and trend
fit_double_ts_production <- HoltWinters(ts_production, gamma=FALSE)

accuracy(forecast(fit_double_ts_production, 180)) # Predictive Accuracy

plot(fit_double_ts_production)

plot(forecast(fit_double_ts_production, 180))
legend('topleft'
       ,c('Actual', 'Forecast', 'Error Bounds (95% Confidence)')
       ,lty=c(1,1,1)
       ,col=c(1,4,240))

# Triple exponential - models level, trend, and seasonal components
fit_triple_ts_production <- HoltWinters(ts_production)

accuracy(forecast(fit_triple_ts_production, 180)) # Predictive Accuracy

plot(fit_triple_ts_production) #red line = filtered time-series

plot(forecast(fit_triple_ts_production, 180))
legend('topleft'
       ,c('Actual', 'Forecast', 'Error Bounds (95% Confidence)')
       ,lty=c(1,1,1)
       ,col=c(1,4,240))



# Ok, as we get the lower value in accuracy using triple exponential Holt Winters, 
# let's predict using Holt Winters 365 days ahead with 95% of confidence interval
predict_triple_ts_production <- predict(fit_triple_ts_production, 365, prediction.interval = TRUE, level = 0.95)

# Plot using the model in triple exponencial Holt Winters using predict object
plot(fit_triple_ts_production
     , predict_triple_ts_production
     , main ='Holt-Winters Forecasting in a Year'
     )

legend('bottomleft'
       ,c('Observed', 'Filtering (before line), Forecast (after line)', 'Error Bounds (95% Confidence)')
       ,lty=c(1,1,1)
       ,col=c(1,2,4)
      )


# References
# [1] - https://stat.ethz.ch/R-manual/R-devel/library/stats/html/stl.html
# [2] - http://www.statmethods.net/advstats/timeseries.html
# [3] - STL: A Seasonal-Trend Decomposition Procedure Based on Loess. Robert B. Cleveland, William S. Cleveland, Jean E. McRae, and Irma Terpenning
#       http://www.jos.nu/Articles/abstract.asp?article=613
# [4] - http://pedrounb.blogspot.com.br/2012/09/previsao-de-series-temporais-usando_27.html
# [5] - https://www.otexts.org/fpp/7/5