
# Load library
if(!require(forecast)){
  install.packages("forecast")
  library(forecast)
}

# Dataset
rj_murder <- read.csv("https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/rj-homicidios-1991-2011.csv")

# Check data
head(rj_murder)

# Transform in time series dataset all metrics inside the dataset 
rj_murder_total <- ts(rj_murder$total, start=c(1991, 1), end=c(2011, 12), frequency=12)
rj_murder_capital <- ts(rj_murder$capital, start=c(1991, 1), end=c(2011, 12), frequency=12)
rj_murder_baixada <- ts(rj_murder$baixada, start=c(1991, 1), end=c(2011, 12), frequency=12)
rj_murder_interior <- ts(rj_murder$interior, start=c(1991, 1), end=c(2011, 12), frequency=12)

#Plot series
par(mfrow=c(2,2))

plot(rj_murder_total
     ,main = "Total de Homicidios no RJ de 1991-2011"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5
     )


plot(rj_murder_capital
     ,main = "Total de Homicidios no RJ de 1991-2011 (Capital)"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5
)


plot(rj_murder_baixada
     ,main = "Total de Homicidios no RJ de 1991-2011 (Baixada)"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5
)


plot(rj_murder_interior
     ,main = "Total de Homicidios no RJ de 1991-2011 (Interior)"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5
)


# Fit ARIMA models
fit_rj_murder_total     <- auto.arima(rj_murder_total)
fit_rj_murder_capital   <- auto.arima(rj_murder_capital) 
fit_rj_murder_baixada   <- auto.arima(rj_murder_baixada)
fit_rj_murder_interior  <- auto.arima(rj_murder_interior)

#Plot ARIMA Models
par(mfrow=c(2,2))
plot(forecast(fit_rj_murder_total,h=12)
     ,main = "Total de Homicidios no RJ de 1991-2011 \n Previsão usando ARIMA"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5)

plot(forecast(fit_rj_murder_capital,h=12)
     ,main = "Total de Homicidios no RJ de 91-2011 (Capital) \n Previsão usando ARIMA"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5)

plot(forecast(fit_rj_murder_baixada,h=12)
     ,main = "Total de Homicidios no RJ de 91-2011 (Baixada) \n Previsão usando ARIMA"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5)

plot(forecast(fit_rj_murder_interior,h=12)
     ,main = "Total de Homicidios no RJ de 91-2011 (Interior) \n Previsão usando ARIMA"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5)



#Forecasting using confidence intervals in 80%, 95% and 99% with 12 months ahead
ahead_rj_murder_total    <- forecast(rj_murder_total, level=c(80, 95, 99), h=12)
ahead_rj_murder_capital  <- forecast(rj_murder_capital, level=c(80, 95, 99), h=12)
ahead_rj_murder_interior <- forecast(rj_murder_interior, level=c(80, 95, 99), h=12)
ahead_rj_murder_baixada  <- forecast(rj_murder_baixada, level=c(80, 95, 99), h=12)

#Plot forecasting
par(mfrow=c(2,2))
plot(ahead_rj_murder_total
     ,main = "Total de Homicidios no RJ de 91-2011 (Total) \n Previsão usando Forecast package"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5
     ,shadecols="oldstyle")

plot(ahead_rj_murder_capital
     ,main = "Total de Homicidios no RJ de 91-2011 (Capital) \n Previsão usando Forecast package"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5
     ,shadecols="oldstyle")

plot(ahead_rj_murder_baixada
     ,main = "Total de Homicidios no RJ de 91-2011 (Baixada) \n Previsão usando Forecast package"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5
     ,shadecols="oldstyle")

plot(ahead_rj_murder_interior
     ,main = "Total de Homicidios no RJ de 91-2011 (Interior) \n Previsão usando Forecast package"
     ,xlab = "Ano"
     ,ylab = "Qtde Homicidios"
     ,type = "l"
     ,lwd = 2.5
     ,shadecols="oldstyle")

#References
#[1] - http://www.inside-r.org/packages/cran/forecast/docs/auto.arima
#[2] - http://www.ucamcesec.com.br/wordpress/wp-content/uploads/2011/04/RJ_2011_evolucao.xls

#[3] - http://www.statmethods.net/advstats/timeseries.html