library(plyr)

# split a data frame by Species, summarize it, then convert the results
# into a data frame
ddply(iris, .(Species), summarise,
      mean_petal_length=mean(Petal.Length)
)
#     Species mean_petal_length
#1     setosa             1.462
#2 versicolor             4.260
#3  virginica             5.552

# split a data frame by Species, summarize it, then convert the results
# into an array
unlist(daply(iris[,4:5], .(Species), colwise(mean)))
#    setosa.Petal.Width versicolor.Petal.Width  virginica.Petal.Width 
#                 0.246                  1.326                  2.026 
