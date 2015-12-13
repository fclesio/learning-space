
#Install mandadory packages
install.packages("zoo")
install.packages("forecast")
install.packages("timeSeries")
install.packages("timeDate")
install.packages("TTR")
install.packages("rmarkdown")

#Invoke libraries
library(ggplot2)
library(redshift)
library(zoo)
library(forecast)
library(timeSeries)
library(graphics)
library(TTR)
library(rmarkdown)

#Object of Direct Connection at the Redshift instance
conn <- redshift.connect("jdbc:postgresql://movile-dw.cmq5tdrdup5x.us-east-1.redshift.amazonaws.com:5439/telecom"
                         ,"bi.etl"
                         ,"2HLhBjqHjO")


#Query (By Carrier)
billing_daily <- dbGetQuery(conn, paste(
  "SELECT inserted_date::date,carrier_id,SUM(active_base_total) AS active_base_total,SUM(movile_gross_revenue_value) AS movile_gross_revenue_value,SUM(billing_total) AS billing_total"
  ,"FROM 
  key_indicator_daily.dashboard_daily"
  ,"WHERE 
  carrier_id IN (1,2,4,5) 
  AND inserted_date::date >= '2015-04-01'
  AND inserted_date::date <= '2015-11-09'
  AND application_id IN (
  /*Vivo*/ 214,480,205,120,743,791,394,558,268,548,150,549,833,270,486,601,744,196,176,541
  ,212,460,543,172,450,217,481,482,415,822,602,858,67,633,68,742,709,828,137
  /*Claro*/,44,45,59,92,104,129,130,131,193,204,213,220,232,233,234,235,239,312,417,422,424,527,553,703,722,807,808,809,810
  /*Oi*/,58,229,404,501,502,503,509,526,533,576,593,627,728,740,763,798,807,747
  /*Tim*/,376,384,339,507,508,522,517,518,515,506,607,603,605,608,624,689,787,725,757,759)	"
  ,"GROUP BY inserted_date::date ,carrier_id"
  ,"ORDER BY inserted_date::date DESC"))


#Query (WL Full)
billing_daily_WL <- dbGetQuery(conn, paste(
  "SELECT inserted_date::date,SUM(active_base_total) AS active_base_total,SUM(movile_gross_revenue_value) AS movile_gross_revenue_value,SUM(billing_total) AS billing_total"
  ,"FROM 
  key_indicator_daily.dashboard_daily"
  ,"WHERE 
  carrier_id IN (1,2,4,5) 
  AND inserted_date::date >= '2015-04-01'
  AND inserted_date::date <= '2015-11-09'
  AND application_id IN (
  /*Vivo*/ 214,480,205,120,743,791,394,558,268,548,150,549,833,270,486,601,744,196,176,541
  ,212,460,543,172,450,217,481,482,415,822,602,858,67,633,68,742,709,828,137
  /*Claro*/,44,45,59,92,104,129,130,131,193,204,213,220,232,233,234,235,239,312,417,422,424,527,553,703,722,807,808,809,810
  /*Oi*/,58,229,404,501,502,503,509,526,533,576,593,627,728,740,763,798,807,747
  /*Tim*/,376,384,339,507,508,522,517,518,515,506,607,603,605,608,624,689,787,725,757,759)	"
  ,"GROUP BY inserted_date::date "
  ,"ORDER BY inserted_date::date DESC"))


#Cast to date
billing_daily$inserted_date <- as.Date(billing_daily$inserted_date)
billing_daily_WL$inserted_date <- as.Date(billing_daily_WL$inserted_date)

#Cast to factor
billing_daily$carrier_id <- as.factor(billing_daily$carrier_id)

#Time series of daily Gross Revenue 
billing_serie<-ts(billing_daily_WL$movile_gross_revenue_value, frequency=1)
plot(billing_serie)

#Apply Holt Winters forecasting - Reference: https://www.otexts.org/fpp/7/5
holt<- HoltWinters(billing_serie, gamma = FALSE)

#Plot Holt forecasting
plot(holt)

#Plot Ajusted Holt forecasting
plot(fitted(holt))

#Plot and predict 143 Days
p <- predict(holt, prediction.interval = TRUE, level = 0.90, n.ahead = 143)
plot(holt, p)

#Forecasting using Holt
holt_forecast<- forecast(holt, h=143)
plot(holt_forecast)


holt_forecast
holt_forecast$upper
holt_forecast$lower



#Forecasting using TBATS
billing_serie_tbats<- tbats(billing_serie)
tbats_forecast<- forecast(billing_serie_tbats, h=150)
plot(tbats_forecast)

tbats_forecast
tbats_forecast$upper
tbats_forecast$lower



#Decomposition
decompose<- stl(billing_serie, t.window=7, s.window="periodic", robust=TRUE)
plot(decompose)

#Remove seasonal variation
billing_serie_decomposed<- decompose(billing_serie)
plot(billing_serie_decomposed)

#We'll remove the seasonal component (e.g. sundays, holydays, etc)
decompose_season_ajusted<- seasadj(decompose)
plot(decompose_season_ajusted)


fcast <- forecast(decompose, method="naive", h=30)
plot(fcast, ylab="Gross Revenue")

fcast
fcast$upper
fcast$lower





# forecast.stl seasonally adjusts the data from an STL decomposition, 
# then uses either ETS or ARIMA models to forecast the result. The seasonal component from the 
# last year of data is added back in to the forecasts. Note that the prediction intervals ignore 
# the uncertainty associated with the seasonal component.
fit<- stlf(billing_serie)
plot(fit)



# fit an ARIMA model of order P, D, Q
fit <- auto.arima(billing_serie)
plot(forecast(fit, 20))


accuracy(fit)


#Moving Average
plot(billing_serie
     ,main="Moving Average of Gross Revenue"
     ,ylab="$"
     ,xlab="Week"
     ,lty=1.5
     ,lwd=c(2.5 2.5))
lines(ma(billing_serie,7),col="red")