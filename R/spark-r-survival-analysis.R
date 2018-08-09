# Install packages
install.packages("sparklyr")
spark_install(version = "2.1.0")

# Update
devtools::install_github("rstudio/sparklyr")

# Dir of install
spark_install_dir()

# Restart the standalone cluster
config <- spark_config()
config$spark.executor.cores <- 4
config$spark.executor.memory <- "4G"

# Context
sc <- spark_connect(master = "local", config = config, version = '2.1.0')

# Context
sc

# Load packages
library(sparklyr)
library(dplyr)
library(survival)

# Dir where the file hosted
ROOT_DIR = '/Volumes/PANZER/Github/learning-space/Datasets/07 - Survival/ovarian.csv'

# Load data
data <- read.table(ROOT_DIR, header = TRUE, sep = ",")

ovarianDF <- read.table(ROOT_DIR, header = TRUE, sep = ",")


# Fit an accelerated failure time (AFT) survival regression model with spark.survreg
ovarianDF <- suppressWarnings(createDataFrame(ROOT_DIR))

aftDF <- ovarianDF

aftTestDF <- ovarianDF

aftModel <- spark.survreg(aftDF, Surv(futime, fustat) ~ ecog_ps + rx)

# Model summary
summary(aftModel)

# Prediction
aftPredictions <- predict(aftModel, aftTestDF)
showDF(aftPredictions)



























attrition <- read_csv("https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/02%20-%20Classification/attrition.csv")






attrition

# transform our data set, and then partition into 'training', 'test'
partitions <- attrition %>%
  sdf_partition(training = 0.5, test = 0.5, seed = 1099)




# fit a linear model to the training dataset
fit <- partitions$training %>%
  ml_linear_regression(response = "mpg", features = c("wt", "cyl"))


fit











# Load training data
df <- read.df(sc, "/Volumes/PANZER/Github/learning-space/Datasets/sample_libsvm_data.txt", source = "libsvm")






training <- df

test <- df

# Fit an binomial logistic regression model with spark.logit
model <- spark.logit(training, label ~ features, maxIter = 10, regParam = 0.3, elasticNetParam = 0.8)

# Model summary
summary(model)

# Prediction
predictions <- predict(model, test)
showDF(predictions)










spark_disconnect(sc)

