


install.packages("devtools")
devtools::install_github("pingles/redshift-r")
install.packages("RJDBC", dependencies=T)
install.packages("/Users/me/Downloads/redshift-r-master", dependencies=F, repos=NULL, type="source")
install.packages("ggplot2", dependencies=T)

require(ggplot2)
require(redshift)

#Object of Direct Connection at the Redshift instance
conn <- redshift.connect("jdbc:postgresql:"
                         ,"user"
                         ,"pass")

# List of tables
tables <- redshift.tables(conn)

# See the column 
cols <- redshift.columns(conn, "schema", "table")

#Query
statuses_by_day <- dbGetQuery(conn, paste(
                                          "SELECT "
                                          ,"FROM 
                                               "
                                          ,"WHERE 
                                              	"
                                          ,"GROUP BY "
                                          ,"ORDER BY "))


#Cast to date
statuses_by_day$inserted_date <- as.Date(statuses_by_day$inserted_date)

#Cast to factor
statuses_by_day$carrier_id <- as.factor(statuses_by_day$carrier_id)

# Plot the datapoints
require(ggplot2)
p <- ggplot(statuses_by_day
            ,aes(x=inserted_date
            ,y=movile_gross_revenue_value))

#Put colors at the datapoints
p + geom_point(aes(color=carrier_id)) + labs(colour = "Carrier", title = "Gross Revenue - Year to Date by Day", x = "Month", y = "Gross Revenue (in R$)") +
  scale_colour_manual(values=c("1"="purple", "2"="red", "4"="yellow", "5"="blue"), 
                      labels=c("1", "2", "3", "4")) + scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))

