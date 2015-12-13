# ARIMA - Carrinho de Compras

library(forecast)

head(cm)

?ts

plot(cm,type="b",pch=19,main="Vendas de carrinhos de m??o")

tsdisplay(cm)

acf (serie)

pacf(serie)

seasonplot(cm)

meu.modelo.1<-auto.arima(cm) 

summary (meu.modelo.1)

tsdisplay(meu.modelo.1$residuals)

tsdiag(meu.modelo.1) 

cpgram(meu.modelo.1$residuals)

hist(meu.modelo.1$residuals) 

qqnorm(meu.modelo.1$residuals) 

qqline(meu.modelo.1$residuals)

shapiro.test(meu.modelo.1$residuals)

previsao<-forecast(meu.modelo.1,h=3) 

plot(previsao)

preditos<-fitted(meu.modelo.1) 

lines(preditos,col=4)

vendas<-c(706,813,1088) 

vendas<-ts(vendas,frequency=12,start=c(2010,1))

meu.modelo.2<-ets(cm)

summary(meu.modelo.2)

plot(previsao.2)

preditos.2<-fitted(meu.modelo.2)

lines(preditos,col=4)

#Refer??ncia: http://slideplayer.com.br/slide/3320979/#


#http://pedrounb.blogspot.com.br/2012/09/previsao-de-series-temporais-usando_27.html

#http://www.statmethods.net/advstats/timeseries.html

#http://www.thertrader.com/



