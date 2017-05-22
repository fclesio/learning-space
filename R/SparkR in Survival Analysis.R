install.packages("sparklyr")
spark_install(version = "2.1.0")

devtools::install_github("rstudio/sparklyr")

library(sparklyr)
library(dplyr)

spark_install_dir()

sc <- spark_connect(master = "local")

sc


