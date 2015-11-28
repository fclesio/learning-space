library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
db <- dbConnect(drv, dbname="ncaa",
                user="YOUR USER NAME", password="YOUR PASSWORD")

q <- "SELECT
        *
      FROM
        game_scores;"

data <- dbGetQuery(db, q)
head(data)
#id         school  game_date spread school_score   opponent opp_score was_home
#1 45111 Boston College 1985-11-16    6.0           21   Syracuse        41    False
#2 45112 Boston College 1985-11-02   13.5           12 Penn State        16    False
#3 45113 Boston College 1985-10-26  -11.0           17 Cincinnati        24    False
#4 45114 Boston College 1985-10-12   -2.0           14       Army        45    False
#5 45115 Boston College 1985-09-28    5.0           10      Miami        45     True
#6 45116 Boston College 1985-09-21    6.5           29 Pittsburgh        22    False
nrow(data)
#[1] 30932
ncol(data)
#[1] 8