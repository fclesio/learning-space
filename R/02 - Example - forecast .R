library(forecast)

# mdeaths: Monthly Deaths from Lung Diseases in the UK
fit <- auto.arima(mdeaths)
#customize your confidence intervals
forecast(fit, level=c(80, 95, 99), h=3)
#         Point Forecast    Lo 80    Hi 80    Lo 95    Hi 95    Lo 99    Hi 99
#Jan 1980       1822.863 1564.192 2081.534 1427.259 2218.467 1302.952 2342.774
#Feb 1980       1923.190 1635.530 2210.851 1483.251 2363.130 1345.012 2501.368
#Mar 1980       1789.153 1495.048 2083.258 1339.359 2238.947 1198.023 2380.283

plot(forecast(fit), shadecols="oldstyle")

