##install.packages("ggplot2")

### IMPORT LIBRARIES ###
library(plyr)
library(ggplot2)
library(lubridate)

### IMPORT DATA ###
account_data <- read.delim("Cohort_Analise.txt")
account_data $date = as.Date(account_data$date)

### COMPUTE AVERAGES ACROSS CUSTOMER BASE ###
monthly_average = ddply(account_data,~date,summarise, avg_revenue=mean(revenue), customers = length(unique(company_name)))

ggplot(monthly_average, aes(x=date, y=avg_revenue)) + geom_line() + labs(title = "Average revenue by Calendar Month for Customers in $", x="Year", y="Average revenue ($)")

### REVENUE BY COHORT ###
cohort = ddply(account_data,~company_name,summarise,cohort=min(date), revenue=sum(revenue), num_months_as_customer = as.numeric(round((as.Date(format(Sys.time(), "%Y-%m-%d")) - min(date))/(365.25/12)) + 1))
cohort_summary = ddply(cohort, ~cohort, summarise, mean_revenue = sum(revenue)/sum(num_months_as_customer) )
ggplot(cohort_summary) + geom_bar(aes(cohort, mean_revenue), stat="identity") + labs(title="Average Monthly Revenue by Cohort", x="Cohort", y="Monthly Revenue")

### COHORT ANALYSIS -- PLOT INDIVIDUAL ACCOUNT GROWTH OVER TIME, USE ALPHA TO EXTRACT PATTERNS ###
accounts= ddply(account_data, .(company_name), transform, cmonth = as.numeric(round((date - min(date))/(365.25/12)) + 1, cohort = min(date)))
ggplot(accounts, aes(x=cmonth, y=revenue, group=company_name)) + geom_line(alpha=0.3) + labs(title="Individual Account Growth Over Time", x = "Months Since Becoming a Paid Customer", y = "Monthly Recurring Revenue")

### COHORT ANALYSIS - PLOT THE AVERAGE ACCOUNT GROWTH OVER TIME ###
average_growth = ddply(accounts, .(cmonth), summarise, avg_revenue = mean(revenue), num = length(company_name))
ggplot(average_growth) + geom_line(aes(cmonth,avg_revenue))  + labs(title="Account Growth Over Time", x = "Months Since Becoming a Paid Account", y = "Monthly Recurring Revenue ($)")

### PLOT THE NUMBER OF CUSTOMERS IN EACH COHORT ###
ggplot(average_growth) + geom_bar(aes(x=cmonth, y=num), stat="identity") + labs(title = "Number of Customers in Each Cohort", x="Months Since Becoming a Paid Customer", y = "Customers")

### PLOT THE AVERAGE revenue OF CUSTOMERS BY DATE JOINED ###
account_data = ddply(account_data, .(company_name), transform, cohort = min(date))
agg = ddply(account_data, .(cohort), summarise, avg_revenue = mean(revenue))
ggplot(agg, aes(x = cohort, y=avg_revenue)) + geom_bar(stat="identity") + labs(title = "Average revenue of Customers by Date Joined", x = "Date Became a Paid Customer", y = "Average revenue ($)")

### COMPARE COHORT REVENUE OVER TIME ###
ggplot(account_data) + geom_line(aes(x=date, y=revenue, group=cohort, colour=cohort))
