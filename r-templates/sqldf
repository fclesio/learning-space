library(sqldf)

sqldf("SELECT
      day
      , avg(temp) as avg_temp
      FROM beaver2
      GROUP BY
      day;")

#   day avg_temp
#1 307 37.57931
#2 308 37.71308

#beavers1 and beavers2 come with base R
beavers <- sqldf("select * from beaver1
                 union all
                 select * from beaver2;")
#head(beavers)
#  day time  temp activ
#1 346  840 36.33     0
#2 346  850 36.34     0
#3 346  900 36.35     0
#4 346  910 36.42     0
#5 346  920 36.55     0
#6 346  930 36.69     0

movies <- data.frame(
  title=c("The Great Outdoors", "Caddyshack", "Fletch", "Days of Thunder", "Crazy Heart"),
  year=c(1988, 1980, 1985, 1990, 2009)
)
boxoffice <- data.frame(
  title=c("The Great Outdoors", "Caddyshack", "Fletch", "Days of Thunder","Top Gun"),
  revenue=c(43455230, 39846344, 59600000, 157920733, 353816701)
)

sqldf("SELECT
        m.*
        , b.revenue
      FROM
        movies m
      INNER JOIN
        boxoffice b
          ON m.title = b.title;")

#               title year   revenue
#1 The Great Outdoors 1988  43455230
#2         Caddyshack 1980  39846344
#3             Fletch 1985  59600000
#4    Days of Thunder 1990 157920733
