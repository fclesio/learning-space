# The following two commands remove any previously installed H2O packages for R.
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
if (! ("methods" %in% rownames(installed.packages()))) { install.packages("methods") }
if (! ("statmod" %in% rownames(installed.packages()))) { install.packages("statmod") }
if (! ("stats" %in% rownames(installed.packages()))) { install.packages("stats") }
if (! ("graphics" %in% rownames(installed.packages()))) { install.packages("graphics") }
if (! ("RCurl" %in% rownames(installed.packages()))) { install.packages("RCurl") }
if (! ("jsonlite" %in% rownames(installed.packages()))) { install.packages("jsonlite") }
if (! ("tools" %in% rownames(installed.packages()))) { install.packages("tools") }
if (! ("utils" %in% rownames(installed.packages()))) { install.packages("utils") }

# Now we download, install and initialize the H2O package for R.
install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-turing/8/R")))

# Load library
library(h2o)

# Start instance with all cores
h2o.init(nthreads = -1, max_mem_size = "8G")

h2o.clusterInfo()

#Production Cluster (Not applicable)
#localH2O <- h2o.init(ip = '10.112.81.210', port =54321, nthreads=-1) # Belo Vale 2
#localH2O <- h2o.init(ip = '10.112.80.74', port =54321, nthreads=-1) # Belo Vale 1

# GBM

# URL with data
LaymanBrothersURL = "https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/02%20-%20Classification/default_credit_card.csv"

# Load data 
creditcard.hex = h2o.importFile(path = LaymanBrothersURL, destination_frame = "creditcard.hex")

# Let's see the summary
summary(creditcard.hex)

# Convert DEFAULT variable to categorical
creditcard.hex[,25] <- as.factor(creditcard.hex[,25])

# We'll get 3 dataframes Train (60%), Test(20%) and Validation (20%)
creditcard.split = h2o.splitFrame(data = creditcard.hex
                                  ,ratios = c(0.6,0.2)
                                  ,destination_frames = c("creditcard.train.hex", "creditcard.valid.hex", "creditcard.test.hex")
                                  ,seed = 12345)

# Get the train dataframe(1st split object)
creditcard.train = creditcard.split[[1]]

# Get the test dataframe(2nd split object)
creditcard.test = creditcard.split[[2]]

# Get the test dataframe(3rd split object)
creditcard.validation = creditcard.split[[3]]


# See datatables from each dataframe
h2o.table(creditcard.train$DEFAULT)

h2o.table(creditcard.test$DEFAULT)

h2o.table(creditcard.validation$DEFAULT)


# Set dependent variable
Y = "DEFAULT"

# Set independent variables
X = c("LIMIT_BAL","EDUCATION","MARRIAGE","AGE"
      ,"PAY_0","PAY_2","PAY_3","PAY_4","PAY_5","PAY_6"
      ,"BILL_AMT1","BILL_AMT2","BILL_AMT3","BILL_AMT4","BILL_AMT5","BILL_AMT6"
      ,"PAY_AMT1","PAY_AMT3","PAY_AMT4","PAY_AMT5","PAY_AMT6")

# Intentionally I removed sex variable from the model, to avoid put any gender bias inside the model. Ethics first guys! ;)

# Train model
creditcard.gbm <- h2o.gbm(y = Y, x = X, training_frame = creditcard.train
                          ,ntrees = 10,max_depth = 3,min_rows = 2
                          ,learn_rate = 0.2, distribution= "AUTO")


# To obtain the Mean-squared Error by tree from the model object:
creditcard.gbm@model$scoring_history

# See algo performance
h2o.performance(creditcard.gbm, newdata = creditcard.test)

# Variable importance
h2o.varimp(creditcard.gbm)

# Predict using GLM model
pred = h2o.predict(object = creditcard.gbm, newdata = creditcard.test)

# See predictions
pred





# Set hyparameters
hyper_params = list( max_depth = seq(1,30,1) )


grid <- h2o.grid(
  hyper_params = hyper_params, search_criteria = list(strategy = "Cartesian"), algorithm="gbm"
  ,grid_id="depth_grid", x = X, y = Y
  ,training_frame = creditcard.train, validation_frame = creditcard.validation, ntrees = 1000
  ,learn_rate = 0.05, learn_rate_annealing = 0.99, sample_rate = 0.8
  ,col_sample_rate = 0.8, seed = 1234, stopping_rounds = 5
  ,stopping_tolerance = 1e-4, stopping_metric = "AUC", score_tree_interval = 10
)


grid                                                                       

## sort the grid models by decreasing AUC
sortedGrid <- h2o.getGrid("depth_grid", sort_by="auc", decreasing = TRUE)    
sortedGrid

## find the range of max_depth for the top 5 models
topDepths = sortedGrid@summary_table$max_depth[1:5]                       
minDepth = min(as.numeric(topDepths))
maxDepth = max(as.numeric(topDepths))
minDepth
maxDepth




