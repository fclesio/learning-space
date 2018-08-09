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

# Production Cluster (Not applicable because we're using in the same machine)
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
                          ,validation_frame = creditcard.validation                      
                          ,ntrees = 100
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

########################
# Parameter Description
########################

# x: A vector containing the names of the predictors to use while building the GBM model.

# y: A character string or index that represents the response variable in the model.

# training frame: An H2OFrame object containing the variables in the model.

# validation frame: An H2OFrame object containing the validation dataset used to construct
# confusion matrix. If blank, the training data is used by default.

# ntrees: A non-negative integer that defines the number of trees. The default is 50.

# seed: Seed containing random numbers that affects sampling.

# max depth: The user-defined tree depth. The default is 5.

# min rows: The minimum number of rows to assign to the terminal nodes. The default is 10.

# learn rate: An integer that defines the learning rate. The default is 0.1 and the range is 0.0 to
# 1.0.

# distribution: Enter AUTO, bernoulli, multinomial, gaussian, poisson, gamma
# or tweedie to select the distribution function. The default is AUTO.

# model id: The unique ID assigned to the generated model. If not specified, an ID is generated
# automatically.

# build tree one node: Specify if GBM should be run on one node only; no network overhead
# but fewer CPUs used. Suitable for small datasets. Default is False.

# balance classes: Balance training data class counts via over or undersampling for imbalanced
# data. The default is FALSE.

# score each iteration: A boolean indicating whether to score during each iteration of model
# training. Default is false.

# ignore const cols: A boolean indicating if constant columns should be ignored. Default is
# True.


# Check the main parameters of the model
creditcard.gbm@parameters

# To obtain the Mean-squared Error by tree from the model object:
creditcard.gbm@model$scoring_history

# See algo performance
h2o.performance(creditcard.gbm, newdata = creditcard.validation)

# H2OBinomialMetrics: gbm

# MSE:  0.1648487
# RMSE:  0.4060157
# LogLoss:  0.8160863
# Mean Per-Class Error:  0.3155595
# AUC:  0.7484422
# Gini:  0.4968843

# Confusion Matrix for F1-optimal threshold:
#   0    1    Error        Rate
# 0      3988  632 0.136797   =632/4620
# 1       653  668 0.494322   =653/1321
# Totals 4641 1300 0.216294  =1285/5941


# We have an AUC of 74,84%, not so bad!

# Variable importance
imp <- h2o.varimp(creditcard.gbm)

head(imp, 20)

# Variable Importances: 
#   variable relative_importance scaled_importance percentage
# 1  EDUCATION        17617.437500          1.000000   0.380798
# 2   MARRIAGE         9897.513672          0.561802   0.213933
# 3      PAY_0         3634.417480          0.206297   0.078557
# 4        AGE         2100.291992          0.119217   0.045397
# 5  LIMIT_BAL         1852.831787          0.105170   0.040049
# 6  BILL_AMT1         1236.516602          0.070187   0.026727
# 7   PAY_AMT5         1018.286499          0.057800   0.022010
# 8  BILL_AMT3          984.673889          0.055892   0.021284
# 9  BILL_AMT2          860.909119          0.048867   0.018608
# 10  PAY_AMT6          856.006531          0.048589   0.018502
# 11  PAY_AMT1          828.846252          0.047047   0.017915
# 12 BILL_AMT6          823.107605          0.046721   0.017791
# 13 BILL_AMT4          809.641785          0.045957   0.017500
# 14  PAY_AMT4          771.504272          0.043792   0.016676
# 15  PAY_AMT3          746.101196          0.042350   0.016127
# 16 BILL_AMT5          723.759521          0.041082   0.015644
# 17     PAY_3          457.857758          0.025989   0.009897
# 18     PAY_5          298.554657          0.016947   0.006453
# 19     PAY_4          268.133453          0.015220   0.005796
# 20     PAY_2          249.107925          0.014140   0.005384


# Predict using GLM model
pred = h2o.predict(object = creditcard.gbm, newdata = creditcard.test)

# See predictions
head(pred, 5)

# predict        p0           p1
# 1       0 0.9990856 0.0009144487
# 2       0 0.9945627 0.0054373206
# 3       0 0.9997726 0.0002273775
# 4       0 0.9968271 0.0031728833
# 5       0 0.9991758 0.0008242144


# Set hyparameters (Did not work using sequence. :o( )
ntrees_list <- list(50,100,150,200)

max_depth_list <- list(1,2,3,4,5,6,7,8,9,10)

learnrate_list <- list(.10,.20,.30,.40,.50,.60,.70,.80,.90)

# Full list of hyper parameters that will be used
hyper_parameters <- list(ntrees = ntrees_list
                         ,max_depth = max_depth_list
                         ,learn_rate = learnrate_list)

# See hyparameters lists
hyper_parameters

# Small piece of advice, the script below can take a LOT time to run. So be careful with the number of parameters!

# Grid Search using GBM
grid <- h2o.grid(
                  hyper_params = hyper_parameters
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


# Using cartesian (combination of all parameters) as a strategy for search, we have in our script 360 models!
# ntrees = 4
# max_depth = 10
# learn_rate = 9
# 4 * 10 * 9 = 360!
# Said that, the run time can be get some time to be done. 

# Take 11m34s to overflow (escalate for the H2O team in Github!) 

# See grid parameters
grid                                                                       

# sort the grid models by decreasing AUC
sortedGrid <- h2o.getGrid("depth_grid", sort_by="auc", decreasing = TRUE)    

# Let's see our models
sortedGrid

# H2O Grid Details
# ================
  
#   Grid ID: depth_grid 
# Used hyper parameters: 
#   -  learn_rate 
# -  max_depth 
# -  ntrees 
# Number of models: 380 
# Number of failed models: 2940 

# Hyper-Parameter Search Summary: ordered by decreasing auc
# learn_rate max_depth ntrees            model_ids                auc
# 1        0.1         6    100 depth_grid_model_200 0.7811807105334736
# 2        0.1         6     50   depth_grid_model_5 0.7811440893197138
# 3        0.2         3    150 depth_grid_model_264 0.7809025695475355
# 4        0.2         3    100 depth_grid_model_174  0.780834324645831
# 5        0.1         6    200 depth_grid_model_380 0.7808292451933633


#Now we got a AUC of 78.11%, an increase of 4% in comparison of the old AUC (74,84%).


# Grab the model_id based in AUC
best_glm_model_id <- sortedGrid@model_ids[[1]]

# The best model
best_glm <- h2o.getModel(best_glm_model_id)

# Summary
summary(best_glm)

# Model Details:
# ==============
  
# H2OBinomialModel: gbm
# Model Key:  depth_grid_model_200 
# Model Summary: 
#   number_of_trees number_of_internal_trees model_size_in_bytes min_depth max_depth mean_depth
# 1             100                      100               52783         6         6    6.00000
# min_leaves max_leaves mean_leaves
# 1         12         56    36.93000

# H2OBinomialMetrics: gbm
# ** Reported on training data. **
  
# MSE:  0.1189855
# RMSE:  0.3449427
# LogLoss:  0.3860698
# Mean Per-Class Error:  0.2593832
# AUC:  0.8371354
# Gini:  0.6742709

# Confusion Matrix for F1-optimal threshold:
# 0    1    Error         Rate
# 0      12424 1623 0.115541  =1623/14047
# 1       1625 2405 0.403226   =1625/4030
# Totals 14049 4028 0.179676  =3248/18077

# Variable importance (again...)
imp2 <- h2o.varimp(best_glm)

head(imp2, 20)

# Variable Importances: 
#   variable relative_importance scaled_importance percentage
# 1      PAY_0         2040.270508          1.000000   0.358878
# 2      PAY_2          902.637390          0.442411   0.158772
# 3  LIMIT_BAL          385.425659          0.188909   0.067795
# 4        AGE          274.609589          0.134595   0.048303
# 5  BILL_AMT1          209.715469          0.102788   0.036888
# 6      PAY_3          168.518372          0.082596   0.029642
# 7  EDUCATION          150.365280          0.073699   0.026449
# 8  BILL_AMT2          146.754837          0.071929   0.025814
# 9      PAY_5          139.303482          0.068277   0.024503
# 10  PAY_AMT5          139.206543          0.068229   0.024486
# 11 BILL_AMT5          133.963348          0.065660   0.023564
# 12     PAY_4          124.926552          0.061230   0.021974
# 13  PAY_AMT6          123.267151          0.060417   0.021682
# 14 BILL_AMT6          114.012253          0.055881   0.020054
# 15  PAY_AMT1          112.402290          0.055092   0.019771
# 16     PAY_6          108.483795          0.053171   0.019082
# 17 BILL_AMT3          103.207893          0.050585   0.018154
# 18  PAY_AMT3           97.335411          0.047707   0.017121
# 19 BILL_AMT4           90.403320          0.044309   0.015902
# 20  MARRIAGE           61.917801          0.030348   0.010891
  

# Get model and put inside a object
model = best_glm

# Prediction using the best model
pred2 = h2o.predict(object = model, newdata = creditcard.validation)

# Frame with predictions
dataset_pred = as.data.frame(pred2)

# Write a csv file
write.csv(dataset_pred, file = "predictions.csv", row.names=TRUE)

# Shutdown the cluster 
h2o.shutdown()

# Are you sure you want to shutdown the H2O instance running at http://localhost:54321/ (Y/N)? Y
# [1] TRUE
