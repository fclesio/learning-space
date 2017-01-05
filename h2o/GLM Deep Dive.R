# Load library
library(h2o)

# Start instance with all cores. 
# The -1 is the parameter to use with all cores. Use this carefully.
# The default parameter is 2 cores. 
h2o.init(nthreads = -1)

# Cluster Info
h2o.clusterInfo()

# R is connected to the H2O cluster: 
#   H2O cluster uptime:         3 seconds 267 milliseconds 
# H2O cluster version:        3.10.0.8 
# H2O cluster version age:    2 months and 26 days  
# H2O cluster name:           H2O_started_from_R_flavio.clesio_udy929 
# H2O cluster total nodes:    1 
# H2O cluster total memory:   1.78 GB 
# H2O cluster total cores:    4 
# H2O cluster allowed cores:  4 
# H2O cluster healthy:        TRUE 
# H2O Connection ip:          localhost 
# H2O Connection port:        54321 
# H2O Connection proxy:       NA 
# R Version:                  R version 3.3.2 (2016-10-31) 


# GLM Demo
# Path of normalized archive. Can be a URL or a local path 
airlinesURL = "https://s3.amazonaws.com/h2o-airlines-unpacked/allyears2k.csv"

# We'll create the object .hex (extention of data files in H2O) 
# and using the importFile property, we'll set the path and the destination frame.
# As default behaviour H2O parse the file automatically.
airlines.hex = h2o.importFile(path = airlinesURL, destination_frame = "airlines.hex")

# Let's see the summary
summary(airlines.hex)

# Construct test and train sets using sampling
# A small note is that H2O uses probabilistic splitting, witch means that resulting splits
# can deviate for the exact number. This is necessary when we're talking about a platform that 
# deals with big data. If you need a exact sampling, the best way is to do this in your RDBMS
airlines.split = h2o.splitFrame(data = airlines.hex,ratios = 0.70, seed = -1)

# Get the train dataframe(1st split object)
airlines.train = airlines.split[[1]]

# Get the test dataframe(2nd split object)
airlines.test = airlines.split[[2]]

# Display a summary using table-like functions
h2o.table(airlines.train$Cancelled)
# Cancelled Count
# 1         0 30085
# 2         1   742

h2o.table(airlines.test$Cancelled)
# Cancelled Count
# 1         0 12807
# 2         1   344


# Set dependent variable (Is departure delayed)
Y = "IsDepDelayed"

# Set independent variables
X = c("Origin", "Dest", "DayofMonth", "Year", "UniqueCarrier", "DayOfWeek", "Month", "DepTime", "ArrTime", "Distance")

# Define the data for the model and display the results
airlines.glm <- h2o.glm(training_frame=airlines.train, x=X, y=Y
                        ,family = "binomial", alpha = 0.5, max_iterations = 300
                        ,beta_epsilon = 0, lambda = 1e-05, lambda_search = FALSE
                        ,early_stopping = FALSE, nfolds = 0, seed = NULL
                        ,intercept = TRUE, gradient_epsilon = -1, remove_collinear_columns = FALSE
                        ,max_runtime_secs = 10000,missing_values_handling = c("Skip"))

########################
# Parameter description
########################

# x: A vector containing the names or indices of the predictor variables to use in
# building the GLM model. If x is missing, then all columns except y are used.

# y: A character string or index that represent the response variable in the model.

# training_frame: An H2OFrame object containing the variables in the model.

# family: A character string specifying the distribution of the model: gaussian, binomial,
# poisson, gamma, tweedie.

# alpha: A numeric in [0, 1] specifying the elastic-net mixing parameter.
# making alpha = 1 the lasso penalty and alpha = 0 the ridge penalty

# max_iterations: A non-negative integer specifying the maximum number of iterations.

# beta_epsilon: A non-negative number specifying the magnitude of the maximum difference
# between the coefficient estimates from successive iterations. Defines the convergence
# criterion for h2o.glm.

# lambda: A non-negative shrinkage parameter for the elastic-net, which multiplies P(α, β)
# in the objective function. When lambda = 0, no elastic-net penalty is applied
# and ordinary generalized linear models are fit.

# lambda_search: A logical value indicating whether to conduct a search over the space of lambda
# values starting from the lambda max, given lambda is interpreted as lambda min.

# early_stopping: A logical value indicating whether to stop early when doing lambda search. H2O
# will stop the computation at the moment when the likelihood stops changing or
# gets (on the validation data).

# nfolds (Optional): Number of folds for cross-validation.

# seed (Optional): Specify the random number generator (RNG) seed for cross-validation
# folds.

# intercept: Logical, include constant term (intercept) in the model.

# gradient_epsilon: Convergence criteria. Converge if gradient l-infinity norm is below this threshold.
# If lambda_search = FALSE and lambda = 0, the default value of
# gradient_epsilon is equal to .000001, otherwise the default value is .0001. If
# lambda_search = TRUE, the conditional values above are 1E-8 and 1E-6 respectively.

# remove_collinear_columns: (Optional) Logical, valid only with no regularization. If set, co-linear columns
# will be automatically ignored (coefficient will be 0).

# max_runtime_secs: Maximum allowed runtime in seconds for model training. Use 0 to disable.

# missing_values_handling: (Optional) Controls handling of missing values. 
# Can be either "MeanImputation" or "Skip". MeanImputation replaces missing values with 
# mean for numeric and most frequent level for categorical, Skip ignores observations with
# any missing value. Applied both during model training *AND* scoring.


# View model information: training statistics, performance, important variables
summary(airlines.glm)


# Model Details:
#   ==============
#   
#   H2OBinomialModel: glm
# Model Key:  GLM_model_R_1483652109289_5 
# GLM Model: summary
# family  link                              regularization number_of_predictors_total
# 1 binomial logit Elastic Net (alpha = 0.5, lambda = 1.0E-5 )                        283
# number_of_active_predictors number_of_iterations  training_frame
# 1                         271                    4 RTMP_sid_aa80_4
# 
# H2OBinomialMetrics: glm
# ** Reported on training data. **
#   
#   MSE:  0.2104294
# RMSE:  0.4587259
# LogLoss:  0.6088603
# Mean Per-Class Error:  0.3544838
# AUC:  0.7296414
# Gini:  0.4592829
# R^2:  0.1578258
# Null Deviance:  41547.63
# Residual Deviance:  36509.7
# AIC:  37053.7
# 
# Confusion Matrix for F1-optimal threshold:
#   NO   YES    Error          Rate
# NO     6575  8067 0.550949   =8067/14642
# YES    2424 12916 0.158018   =2424/15340
# Totals 8999 20983 0.349910  =10491/29982
# 
# Maximum Metrics: Maximum metrics at their respective thresholds
# metric threshold    value idx
# 1                       max f1  0.402173 0.711175 278
# 2                       max f2  0.138083 0.841055 376
# 3                 max f0point5  0.548135 0.680223 192
# 4                 max accuracy  0.511210 0.669435 215
# 5                max precision  0.984229 1.000000   0
# 6                   max recall  0.046126 1.000000 396
# 7              max specificity  0.984229 1.000000   0
# 8             max absolute_mcc  0.511210 0.338686 215
# 9   max min_per_class_accuracy  0.512992 0.668840 214
# 10 max mean_per_class_accuracy  0.511210 0.669375 215

# Get the variable importance of the models
h2o.varimp(airlines.glm)

# Standardized Coefficient Magnitudes: standardized coefficient magnitudes
# names coefficients sign
# 1 Origin.LIH     3.573677  NEG
# 2 Origin.TLH     3.054208  NEG
# 3   Dest.LYH     2.520234  POS
# 4 Origin.KOA     2.455275  NEG
# 5 Origin.SRQ     2.432524  POS
# 
# ---
#   names coefficients sign
# 278 Origin.ABE     0.000000  POS
# 279 Origin.GEG     0.000000  POS
# 280 Origin.LAN     0.000000  POS
# 281 Origin.SBN     0.000000  POS
# 282 Origin.SMF     0.000000  POS
# 283 Origin.TRI     0.000000  POS


# Predict using GLM model
pred = h2o.predict(object = airlines.glm, newdata = airlines.test)

# Look at summary of predictions: probability of TRUE class (p1)
summary(pred)

# predict   NO                YES              
# YES:8903  Min.   :0.01646   Min.   :0.02357  
# NO :3863  1st Qu.:0.33613   1st Qu.:0.36628  
# NA : 385  Median :0.48300   Median :0.51604  
#           Mean   :0.48714   Mean   :0.51286  
#           3rd Qu.:0.63276   3rd Qu.:0.66291  
#           Max.   :0.97643   Max.   :0.98354  
#           NA's   :385       NA's   :385  
 


# Construct a large Cartesian hyper-parameter space
alpha_opts = c(0,0.10,0.15,0.25,0.35,0.50,0.65,0.75,0.85,1)

# List of hyperparameters
hyper_params_opt = list(alpha = alpha_opts)

# Grid object with hyperparameters
glm_grid <- h2o.grid("glm",grid_id = "glm_grid_1", x=X, y=Y, training_frame=airlines.train,
                     hyper_params = hyper_params_opt, family = "binomial")

# Sort grids by best performance (lower MSE)
glm_sorted_grid <- h2o.getGrid(grid_id = "glm_grid_1", sort_by = "mse")

#Print the models
print(glm_sorted_grid)

# Grab the model_id for the top GBM model, chosen by validation AUC
best_glm_model_id <- glm_grid@model_ids[[1]]

best_glm <- h2o.getModel(best_glm_model_id)


summary(best_glm)



best_glm_perf <- h2o.performance(model = best_glm, 
                                 newdata = airlines.test)
h2o.auc(best_glm_perf)  

best_glm_perf

model = best_glm

pred = h2o.predict(object = airlines.glm, newdata = airlines.test)
pred2 = h2o.predict(object = model, newdata = airlines.test)

# Shutdown the cluster 
h2o.shutdown()
# Are you sure you want to shutdown the H2O instance running at http://localhost:54321/ (Y/N)? Y
# [1] TRUE

