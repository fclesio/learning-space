library(reshape2)

# generate a unique id for each row; this let's us go back to wide format later
iris$id <- 1:nrow(iris)

iris.lng <- melt(iris, id=c("id", "Species"))
head(iris.lng)
#  id Species     variable value
#1  1  setosa Sepal.Length   5.1
#2  2  setosa Sepal.Length   4.9
#3  3  setosa Sepal.Length   4.7
#4  4  setosa Sepal.Length   4.6
#5  5  setosa Sepal.Length   5.0
#6  6  setosa Sepal.Length   5.4

iris.wide <- dcast(iris.lng, id + Species ~ variable)
head(iris.wide)
#  id Species Sepal.Length Sepal.Width Petal.Length Petal.Width
#1  1  setosa          5.1         3.5          1.4         0.2
#2  2  setosa          4.9         3.0          1.4         0.2
#3  3  setosa          4.7         3.2          1.3         0.2
#4  4  setosa          4.6         3.1          1.5         0.2
#5  5  setosa          5.0         3.6          1.4         0.2
#6  6  setosa          5.4         3.9          1.7         0.4

library(ggplot2)

# plots a histogram for each numeric column in the dataset
p <- ggplot(aes(x=value, fill=Species), data=iris.lng)
p + geom_histogram() +
  facet_wrap(~variable, scales="free")