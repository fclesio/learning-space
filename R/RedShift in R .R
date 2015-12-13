


install.packages("devtools")
devtools::install_github("pingles/redshift-r")
install.packages("RJDBC", dependencies=T)
install.packages("/Users/me/Downloads/redshift-r-master", dependencies=F, repos=NULL, type="source")
install.packages("ggplot2", dependencies=T)

require(ggplot2)
require(redshift)

#Object of Direct Connection at the Redshift instance
conn <- redshift.connect("jdbc:postgresql://movile-dw.cmq5tdrdup5x.us-east-1.redshift.amazonaws.com:5439/telecom"
                         ,"bi.etl"
                         ,"2HLhBjqHjO")

# List of tables
tables <- redshift.tables(conn)

# See the column 
cols <- redshift.columns(conn, "key_indicator_daily", "dashboard_daily")

#Query
statuses_by_day <- dbGetQuery(conn, paste(
                                          "SELECT inserted_date::date,carrier_id,SUM(active_base_total) AS active_base_total,SUM(movile_gross_revenue_value) AS movile_gross_revenue_value,SUM(billing_total) AS billing_total"
                                          ,"FROM 
                                               key_indicator_daily.dashboard_daily"
                                          ,"WHERE 
                                              carrier_id IN (1,2,4,5) 
                                              AND inserted_date::date >= '2015-04-01'
                                              AND application_id IN (
                                          /*Vivo*/ 214,480,205,120,743,791,394,558,268,548,150,549,833,270,486,601,744,196,176,541
                                          ,212,460,543,172,450,217,481,482,415,822,602,858,67,633,68,742,709,828,137
                                          /*Claro*/,44,45,59,92,104,129,130,131,193,204,213,220,232,233,234,235,239,312,417,422,424,527,553,703,722,807,808,809,810
                                          /*Oi*/,58,229,404,501,502,503,509,526,533,576,593,627,728,740,763,798,807,747
                                          /*Tim*/,376,384,339,507,508,522,517,518,515,506,607,603,605,608,624,689,787,725,757,759)	"
                                          ,"GROUP BY inserted_date::date ,carrier_id"
                                          ,"ORDER BY inserted_date::date DESC"))


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
                      labels=c("Vivo", "Claro", "Oi", "Tim")) + scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE))

