######################################################
#Classical Seasonal Decomposition by Moving Averages
######################################################

#Original Link: https://stat.ethz.ch/R-manual/R-devel/library/stats/html/decompose.html
 
#Description
#Decompose a time series into (i) seasonal, (ii) trend and (iii) irregular components using moving averages. Deals with additive or multiplicative seasonal component.
 
#Additive Mode: Y[t] = T[t] + S[t] + e[t]
#Additive:  xt = Trend + Seasonal + Random
#The additive model is useful when the seasonal variation is relatively constant over time.

#Multiplicative model: Y[t] = T[t] * S[t] * e[t]
#Multiplicative:  xt = Trend * Seasonal * Random
#The multiplicative model is useful when the seasonal variation increases over time.

#Case of Implementation
# Prever o comportamento de series nas quais há diversos elementos explicativos. 
# Ajuda a entender a sazonalidade e o ciclo.
#A serie pode ter influencia de diversos fatores

# For quarterly data, it might be name of series = ts(name of series, freq =4).
# For monthly data, it might be name of series = ts(name of series, freq = 12).  

# O que precisa ser decomposto:
# (i) tendência: Direcao geral de onde os datapoints estao indo (e.g. melhorias graduais, perdas ao longo do tempo) 
# (ii) variações cíclicas: Efeitos recorrentes ao longo da serie, mas que nao tem a periodicidade da sazonalidade (e.g. Natal, Dia dos pais, Pascoa)
# (iii) variações sazonais: Oscilacoes relativas a um determinado periodo de tempo (e.g. ferias, volta as aulas, vendas no final de ano, 13 salario)
# (iv)variações irregulares: Variacoes inexplicaveis (e.g. cisnes negros)
# (Corrar e Theóphilo (2004))

#I've changed the original script. Instead use require() I use library()
library(graphics)

#Strutucture of the dataset
str(co2)

#See the first rows of the dataset
head(co2)

#Using the function decompose
m <- decompose(co2)

#See the seasonal effects in all quarters
m$figure

#See the seasonal patterns
m$seasonal

#See the trend
m$trend

#See the random element
m$random

plot(m)

## example taken from Kendall/Stuart
x <- c(-50, 175, 149, 214, 247, 237, 225, 329, 729, 809,
       530, 489, 540, 457, 195, 176, 337, 239, 128, 102, 232, 429, 3,
       98, 43, -141, -77, -13, 125, 361, -45, 184)

#We'll use the data points above to plot a series from 1 quarter of 1951 to las tquarter of 1958. Frequency it's the window slice.
x <- ts(x, start = c(1951, 1), end = c(1958, 4), frequency = 4)

#Decompose function (Additive)
m <- decompose(x, type="add")

m$figure

## seasonal figure: 6.25, 8.62, -8.84, -6.03
round(decompose(x)$figure / 10, 2)

plot(m)


#Decompose function (Multiplicative)
m <- decompose(x, type="mult")

plot(m)


##############
# References
##############

# https://onlinecourses.science.psu.edu/stat510/?q=book/export/html/69

# http://www.anpad.org.br/periodicos/arq_pdf/a_1320.pdf

# https://nepom.wordpress.com/2014/02/23/o-segredo-de-luiza/
