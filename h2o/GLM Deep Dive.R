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

# Predict using GLM model
pred = h2o.predict(object = airlines.glm, newdata = airlines.test)

# Look at summary of predictions: probability of TRUE class (p1)
summary(pred$p1)




airlines.glm <- h2o.glm(training_frame=airlines.train, x=X, y=Y, family = "binomial", alpha = 0.5, max_iterations = 50, beta_epsilon = 0, , lambda = 1e-05, lambda_search = FALSE
                        ,early_stopping = FALSE, nfolds = 0, seed = NULL, intercept = TRUE, gradient_epsilon = -1, remove_collinear_columns = FALSE, max_runtime_secs = 0,
                        missing_values_handling = c("Skip"))


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

