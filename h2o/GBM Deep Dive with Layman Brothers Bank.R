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

# Info about cluster
h2o.clusterInfo()

#Production Cluster (Not applicable)
#localH2O <- h2o.init(ip = '10.112.81.210', port =54321, nthreads=-1) # Server 1
#localH2O <- h2o.init(ip = '10.112.80.74', port =54321, nthreads=-1) # Server 2

# Gradient Boosting Machines

# URL with data
LaymanBrothersURL = "https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/02%20-%20Classification/default_credit_card.csv"

# Load data 
creditcard.hex = h2o.importFile(path = LaymanBrothersURL, destination_frame = "creditcard.hex")

# Convert DEFAULT, SEX, EDUCATION, MARRIAGE variables to categorical
creditcard.hex[,25] <- as.factor(creditcard.hex[,25]) # DEFAULT

creditcard.hex[,3] <- as.factor(creditcard.hex[,3]) # SEX

creditcard.hex[,4] <- as.factor(creditcard.hex[,4]) # EDUCATION

creditcard.hex[,5] <- as.factor(creditcard.hex[,5]) # MARRIAGE

# Let's see the summary
summary(creditcard.hex)

# We'll get 3 dataframes Train (60%), Test (20%) and Validation (20%)
creditcard.split = h2o.splitFrame(data = creditcard.hex
                                  ,ratios = c(0.6,0.2)
                                  ,destination_frames = c("creditcard.train.hex", "creditcard.test.hex", "creditcard.validation.hex")
                                  ,seed = 12345)

# Get the train dataframe(1st split object)
creditcard.train = creditcard.split[[1]]

# Get the test dataframe(2nd split object)
creditcard.test = creditcard.split[[2]]

# Get the validation dataframe(3rd split object)
creditcard.validation = creditcard.split[[3]]


# See datatables from each dataframe
h2o.table(creditcard.train$DEFAULT)

# DEFAULT Count
# 1       0 14047
# 2       1  4030

h2o.table(creditcard.test$DEFAULT)

# DEFAULT Count
# 1       0  4697
# 2       1  1285

h2o.table(creditcard.validation$DEFAULT)

# DEFAULT Count
# 1       0  4620
# 2       1  1321

# Set dependent variable
Y = "DEFAULT"

# Set independent variables
X = c("LIMIT_BAL","EDUCATION","MARRIAGE","AGE"
      ,"PAY_0","PAY_2","PAY_3","PAY_4","PAY_5","PAY_6"
      ,"BILL_AMT1","BILL_AMT2","BILL_AMT3","BILL_AMT4","BILL_AMT5","BILL_AMT6"
      ,"PAY_AMT1","PAY_AMT3","PAY_AMT4","PAY_AMT5","PAY_AMT6")

# I intentionally removed sex variable from the model, to avoid put any gender bias inside the model. Ethics first guys! ;)

# Train model
creditcard.gbm <- h2o.gbm(y = Y
                          ,x = X
                          ,training_frame = creditcard.train
                          ,ntrees = 100
                          ,validation_frame = creditcard.validation
                          ,seed = 12345
                          ,max_depth = 100
                          ,min_rows = 10
                          ,learn_rate = 0.2
                          ,distribution= "bernoulli"
                          ,model_id = 'gbm_layman_brothers_model'
                          ,build_tree_one_node = TRUE
                          ,balance_classes = TRUE
                          ,score_each_iteration = TRUE
                          ,ignore_const_cols = TRUE
                          )


# Check the main parameters of the model
creditcard.gbm@parameters

# To obtain the Mean-squared Error by tree from the model object:
creditcard.gbm@model$scoring_history

# See algo performance
h2o.performance(creditcard.gbm, newdata = creditcard.validation)

# H2OBinomialMetrics: gbm

# MSE:  0.1398498
# RMSE:  0.373965
# LogLoss:  0.4599217
# Mean Per-Class Error:  0.2998072
# AUC:  0.7589642
# Gini:  0.5179284

# Confusion Matrix for F1-optimal threshold:
#   0    1    Error        Rate
# 0      3891  806 0.171599   =806/4697
# 1       550  735 0.428016   =550/1285
# Totals 4441 1541 0.226680  =1356/5982


# Variable importance
h2o.varimp(creditcard.gbm)

# Variable Importances: 
#   variable relative_importance scaled_importance percentage
# 1     PAY_0         3619.597656          1.000000   0.257411
# 2 LIMIT_BAL         1262.526123          0.348803   0.089786
# 3       AGE         1201.132080          0.331841   0.085420
# 4 BILL_AMT1          781.192810          0.215823   0.055555
# 5 EDUCATION          759.597046          0.209857   0.054019


# Predict using GLM model
pred = h2o.predict(object = creditcard.gbm, newdata = creditcard.test)

# See predictions
pred

# predict        p0         p1
# 1       0 0.9765618 0.02343815
# 2       0 0.7837817 0.21621831
# 3       0 0.9832879 0.01671212
# 4       0 0.8989057 0.10109427
# 5       0 0.9795999 0.02040010
# 6       1 0.7104697 0.28953029




# Set hyparameters
#hyper_params = list( max_depth = seq(1,30,1) )

max_depth_list <- list( max_depth = seq(1,30,1))
ntrees_list <- list( ntrees = seq(50,300,50))
#learnrate_list <- list( learnrate = seq(0.1,0.90,0.1))
learnrate_list <- list(.10,.20,.30,.40,.50,.60,.70,.80,.90)


hyper_parameters <- list(ntrees=ntrees_list)
                         #,max_depth=maxdepth_list)
                         #,learn_rate=learnrate_list)







# See hyparameters
hyper_params

# Grid Search using GBM
grid <- h2o.grid(
                  hyper_params = hyper_params
                  ,search_criteria = list(strategy = "Cartesian")
                  ,algorithm="gbm"
                  ,grid_id="depth_grid"
                  ,x = X
                  ,y = Y
                  ,training_frame = creditcard.train
                  ,validation_frame = creditcard.validation
                  ,learn_rate_annealing = 0.99
                  ,sample_rate = 0.8
                  ,col_sample_rate = 0.8
                  ,seed = 12345
                  ,stopping_rounds = 5
                  ,stopping_tolerance = 1e-6
                  ,stopping_metric = "AUC"
                  ,score_tree_interval = 10
                )

# See grid parameters
grid                                                                       

## sort the grid models by decreasing AUC
sortedGrid <- h2o.getGrid("depth_grid", sort_by="auc", decreasing = TRUE)    
sortedGrid


# Grab the model_id based in AUC
best_glm_model_id <- sortedGrid@model_ids[[1]]

# The best model
best_glm <- h2o.getModel(best_glm_model_id)

# Summary
summary(best_glm)

# Get model and put inside a object
model = best_glm

# Prediction using the best model
pred2 = h2o.predict(object = model, newdata = creditcard.validation)

# Frame with predictions
datasdet_pred = as.data.frame(pred2)

# Write a csv file
write.csv(datasdet_pred, file = "predictions.csv", row.names=TRUE)

# Shutdown the cluster 
h2o.shutdown()

# Are you sure you want to shutdown the H2O instance running at http://localhost:54321/ (Y/N)? Y
# [1] TRUE
