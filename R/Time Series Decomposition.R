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

#Import Huston Flights Dataset
dt <- data.table(hflights)


dt[, date := ISOdate(Year, Month, DayofMonth)]




> daily <- dt[, list(
  + N = .N,
  + Delays = sum(ArrDelay, na.rm = TRUE),
  + Cancelled = sum(Cancelled),
  + Distance = mean(Distance)
  + ), by = date]
> str(daily)





plot(ts(daily))


setorder(daily, date)

plot(ts(daily))



plot(ts(daily$N, start = 2011, frequency = 365),
     + main = 'Number of flights from Houston in 2011')



#Decompose seasonality 
plot(decompose(ts(daily$N, frequency = 7)))


#See the effects of the seasonality 
setNames(decompose(ts(daily$N, frequency = 7))$figure,
         + weekdays(daily$date[1:7]))



#Holt-Winters filtering
nts <- ts(daily$N, frequency = 7)
fit <- HoltWinters(nts, beta = FALSE, gamma = FALSE)
plot(fit)

#red line represents the filtered time-series



fit <- HoltWinters(nts)
plot(fit)



forecast(fit)


#Forecast from HoltWinters
plot(forecast(HoltWinters(nts), 31))


# The blue points shows the estimates for the 31 future time periods and the gray area
# around that covers the confidence intervals returned by the forecast function.


