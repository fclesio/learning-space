#####################################################################
# Forecasting Delinquency Loans in Brazil using auto.arima package
#####################################################################

# Importing package
library(forecast)

# Contains data of Time Series System of Central Bank of Brazil (BACEN) - Inadimplência da carteira de crédito - Pessoas físicas - Total
non_performing_loans <- read.csv('https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/08%20-%20Time%20Series/inadimplencia_non_performing_loans_individuals.csv')

# Transformation in time series
ts_npl <- ts(non_performing_loans$percent,start=c(2011,3),end=c(2016,7),frequency=12)

# Fitting using auto-arima method
fit <- auto.arima(ts_npl)

# Put two confidence intervals
forecast(fit, level=c(95, 99), h=6)

# Point Forecast    Lo 95    Hi 95    Lo 99    Hi 99
# Aug 2016       4.101114 3.960100 4.242128 3.915791 4.286438
# Sep 2016       4.039217 3.827343 4.251091 3.760767 4.317666
# Oct 2016       4.073931 3.787839 4.360024 3.697943 4.449920
# Nov 2016       4.131194 3.736105 4.526284 3.611959 4.650430
# Dec 2016       4.099949 3.601776 4.598123 3.445239 4.754660
# Jan 2017       4.102117 3.515139 4.689094 3.330697 4.873536

# Plot forecast
plot(forecast(fit), shadecols="oldstyle")