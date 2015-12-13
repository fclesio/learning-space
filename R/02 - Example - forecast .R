
# Load library
if(!require(forecast)){
  install.packages("forecast")
  library(forecast)
}



# Dataset
mdeaths

# mdeaths: Monthly Deaths from Lung Diseases in the UK
fit <- auto.arima(mdeaths)

#customize your confidence intervals
forecast(fit, level=c(80, 95, 99), h=12)


plot(forecast(fit), shadecols="oldstyle")



#Reference
#[1] - http://www.inside-r.org/packages/cran/forecast/docs/auto.arima