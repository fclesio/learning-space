

# General Info
# http://sexualitics.github.io/

# Load working packages
library(plotly)

# Load data
xhamsterData <- read.csv(file="/Users/paradoxuniverse/desktop/xhamster.csv", header=TRUE, sep=",")

# Check load and see the data
head(xhamsterData)

#Summary of the data
summary(xhamsterData)

# Ajustment of the upload_date variable
xhamsterData$upload_date <- as.Date(xhamsterData[["upload_date"]])

# Structure of the file
str(xhamsterData)


hist(xhamsterData$nb_views, breaks=5, freq = F)

library(ggplot2)

qplot(xhamsterData$nb_views, geom="histogram",  binwidth = 0.5) 