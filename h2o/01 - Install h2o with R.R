#  Source

# The following two commands remove any previously installed H2O packages for R.
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
pkgs <- c("methods","statmod","stats","graphics","RCurl","jsonlite","tools","utils")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Now we download, install and initialize the H2O package for R.
install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-turing/6/R")))
library(h2o)
localH2O = h2o.init(nthreads=-1)


# R is connected to the H2O cluster: 
#   H2O cluster uptime:         5 seconds 18 milliseconds 
# H2O cluster version:        3.10.0.6 
# H2O cluster version age:    15 days  
# H2O cluster name:           H2O_started_from_R_flavio.clesio_khb584 
# H2O cluster total nodes:    1 
# H2O cluster total memory:   1.78 GB 
# H2O cluster total cores:    4 
# H2O cluster allowed cores:  4 
# H2O cluster healthy:        TRUE 
# H2O Connection ip:          localhost 
# H2O Connection port:        54321 
# H2O Connection proxy:       NA 
# R Version:                  R version 3.2.3 (2015-12-10)

# Finally, let's run a demo to see H2O at work.


demo(h2o.kmeans)

# Memory size
localH2O <- h2o.init(ip = 'localhost', port = 54321, max_mem_size = '4g')

# Cluster Info
library(h2o)
localH2O = h2o.init(ip = 'localhost', port = 54321)
h2o.clusterInfo(localH2O)


# Import Data
h2o.init(ip = "localhost", port = 54321, startH2O = TRUE)
prosPath = system.file("extdata", "prostate.csv", package = "h2o")
prostate.hex = h2o.importFile(path = prosPath, destination_frame = "prostate.hex")
class(prostate.hex)
summary(prostate.hex)


# Transform in an dataframe
prostate <- as.data.frame(prostate.hex)
summary(prostate)
head(prostate)

# Convert to factor
prostate.hex[,4] = as.factor(prostate.hex[,4])


# Random samping
prosPath = system.file("extdata", "prostate.csv", package="h2o")
# prostate.hex = h2o.importFile(localH2O, path = prosPath, key = "prostate.hex") # Broken
s = h2o.runif(prostate.hex)
summary(s)

prostate.train = prostate.hex[s <= 0.8,]
prostate.train = h2o.assign(prostate.train, "prostate.train")
prostate.test = prostate.hex[s > 0.8,]
prostate.test = h2o.assign(prostate.test, "prostate.test")
nrow(prostate.train) + nrow(prostate.test)

