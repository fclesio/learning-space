#Based in Mastering Data Analysis with R

#Install basic packages
install.packages('stats')
install.packages('hflights')
install.packages('data.table')

##Import basic libraries 
library(stats)
library(hflights)
library(data.table)
library(forecast)



# Autoregressive Integrated Moving Average - (ARIMA) models must be 
# used only in stationary data, i.e. with constant Mean, Variance and autocorrelation


#Autoregressive Moving Average (ARMA)