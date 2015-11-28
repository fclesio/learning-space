library(plyr)
library(XML)

# build a vector of URL pages we'll want to use
urls <- paste("http://crantastic.org/popcon?page=", 1:10, sep = "")

# scrape all the data from the URLs into one big data.frame
packages.df <- ldply(urls, function(url)readHTMLTable(url)[[1]])

# turn the "Users" column from factor to numeric
packages.df$Users <- as.numeric(as.character(packages.df$Users))

# sort by decreasing "Users"
packages.df <- arrange(packages.df, desc(Users))

# print the 50 most used packages
head(packages.df$`Package Name`, 50)

# [1] ggplot2          plyr        data.table            reshape     Sim.DiffProc
# [6] Sim.DiffProcGUI  lme4        Hmisc                 lattice     RODBC
# [11] randomForest    xtable      RColorBrewer          stringr     sp
# [16] RSQLite         MASS        foreign               RTextTools  quantmod
# [21] foreach         xts         reshape2              XML         car
# [26] cacheSweave     twitteR     zoo                   rgl         maxent
# [31] Matrix          survival    latticeExtra          ape         maptools
# [36] survey          RMySQL      vegan                 rJava       nlme
# [41] xlsReadWrite    tikzDevice  PerformanceAnalytics  rpart       MCMCglmm
# [46] rgdal           boot        Rcmdr                 Rcpp        fortunes



library(wordcloud)
wordcloud(packages.df$`Package Name`,
          packages.df$Users,
          max.words = 50,
          colors = brewer.pal(9, "Greens")[4:9])
