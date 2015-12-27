library(stats)
library(forecast)


oil_production <- read.csv('https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/oil_production_2000_2015.csv')

# Check variables data types
str(oil_production)

#Basic statistics
summary(oil_production)


plot(ts(oil_production$Value))


