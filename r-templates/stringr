library(stringr)

names(iris)
#[1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"
names(iris) <- str_replace_all(names(iris), "[.]", "_")
names(iris)
#[1] "Sepal_Length" "Sepal_Width"  "Petal_Length" "Petal_Width"  "Species"

s <- c("Go to Heaven for the climate, Hell for the company.")
str_extract_all(s, "[H][a-z]+ ")
#[[1]]
#[1] "Heaven " "Hell "  
