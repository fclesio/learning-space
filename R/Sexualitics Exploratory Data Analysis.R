
#-------------------------------
# General Info
# http://sexualitics.github.io/
#-------------------------------

# Load working packages
library(plotly)
library(ggplot2)
library(scales)

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

# Views per days
viewsPerDays <- aggregate(xhamsterData$nb_views
                       ,list(upload_date = xhamsterData$upload_date)
                       ,sum) 


# Top 10 days in views
top10days <- viewsPerDays[order(-viewsPerDays$x),] 

head(top10days, 10)


# Runtime per days (Mean)
runtimePerDays <- aggregate(xhamsterData$runtime
                            ,list(upload_date = xhamsterData$upload_date)
                            ,mean)

top10daysRuntime <- runtimePerDays[order(-runtimePerDays$x),]

head(top10daysRuntime, 10)


# Comments per day (sum)
commentsPerDays <- aggregate(xhamsterData$nb_comments
                             ,list(upload_date = xhamsterData$upload_date)
                             ,sum)

top10daysComments <- commentsPerDays[order(-commentsPerDays$x),]


head(top10daysComments, 10)


# Top 10 uploaders
uploaders <- aggregate(xhamsterData$id
                       ,list(uploaders = xhamsterData$uploader)
                       ,mean)

top10daysUploaders <- uploaders[order(-uploaders$x),]

head(top10daysUploaders, 10)


# Views by year
ggplot(xhamsterData, aes(upload_date, nb_views)) + geom_line() +
   xlab("") + ylab("Daily Views") +
  ggtitle("Views by Year") + scale_y_continuous(labels = comma, breaks=c(1000000,2000000,3000000,4000000,5000000,6000000,7000000,8000000,9000000,10000000))


# Comments by year
ggplot(xhamsterData, aes(upload_date, nb_comments)) + geom_line() +
  xlab("") + ylab("Daily Comments") +
  ggtitle("Views by Comments") + scale_y_continuous(labels = comma, breaks=c(100,200,300,400,500,600,700,800,900,10000))

#Split data in minor parts do perform some analysis
xhamsterData2013 <- subset(xhamsterData,upload_date>"2013-01-01")

xhamsterData2012 <- subset(xhamsterData,upload_date<="2012-12-31" & upload_date>="2012-01-01")

xhamsterData2011 <- subset(xhamsterData,upload_date<="2011-12-31" & upload_date>="2011-01-01")

xhamsterData2010 <- subset(xhamsterData,upload_date<="2010-12-31" & upload_date>="2010-01-01")

xhamsterData2009 <- subset(xhamsterData,upload_date<="2009-12-31" & upload_date>="2009-01-01")

xhamsterData2008 <- subset(xhamsterData,upload_date<="2008-12-31" & upload_date>="2008-01-01")


ggplot(xhamsterData2008, aes(upload_date, nb_views)) + geom_line() +
  xlab("") + ylab("Daily Views") +
  ggtitle("Views by Day - 2008") + scale_y_continuous(labels = comma, breaks=c(1000000,2000000,3000000,4000000,5000000,6000000,7000000,8000000,9000000,10000000))

ggplot(xhamsterData2009, aes(upload_date, nb_views)) + geom_line() +
  xlab("") + ylab("Daily Views") +
  ggtitle("Views by Day - 2009") + scale_y_continuous(labels = comma, breaks=c(1000000,2000000,3000000,4000000,5000000,6000000,7000000,8000000,9000000,10000000))

ggplot(xhamsterData2010, aes(upload_date, nb_views)) + geom_line() +
  xlab("") + ylab("Daily Views") +
  ggtitle("Views by Day - 2010") + scale_y_continuous(labels = comma, breaks=c(1000000,2000000,3000000,4000000,5000000,6000000,7000000,8000000,9000000,10000000))

ggplot(xhamsterData2011, aes(upload_date, nb_views)) + geom_line() +
  xlab("") + ylab("Daily Views") +
  ggtitle("Views by Day - 2011") + scale_y_continuous(labels = comma, breaks=c(1000000,2000000,3000000,4000000,5000000,6000000,7000000,8000000,9000000,10000000))

ggplot(xhamsterData2012, aes(upload_date, nb_views)) + geom_line() +
  xlab("") + ylab("Daily Views") +
  ggtitle("Views by Day - 2012") + scale_y_continuous(labels = comma, breaks=c(1000000,2000000,3000000,4000000,5000000,6000000,7000000,8000000,9000000,10000000))

ggplot(xhamsterData2013, aes(upload_date, nb_views)) + geom_line() +
  xlab("") + ylab("Daily Views") +
  ggtitle("Views by Day - 2013") + scale_y_continuous(labels = comma, breaks=c(1000000,2000000,3000000,4000000,5000000,6000000,7000000,8000000,9000000,10000000)) 



# Put Moving Average at Dataset (Calculate)
m.av <- rollmean(xhamsterData2011$nb_views, 14, fill = list(NA, NULL, NA))

#Add calculated moving averages to existing data frame
xhamsterData2011$amb.av=coredata(m.av)

