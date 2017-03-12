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


# GLM Demo Deep Dive
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

# Display a summary using table-like in some sumarized way
h2o.table(airlines.train$Cancelled)
# Cancelled Count
# 1         0 29921
# 2         1   751

h2o.table(airlines.test$Cancelled)
# Cancelled Count
# 1         0 12971
# 2         1   335

# Set dependent variable (Is departure delayed)
Y = "IsDepDelayed"

# Set independent variables
X = c("Origin", "Dest", "DayofMonth", "Year", "UniqueCarrier", "DayOfWeek", "Month", "DepTime", "ArrTime", "Distance")

# Define the data for the model and display the results
airlines.glm <- h2o.glm(training_frame=airlines.train
                        ,x=X
                        ,y=Y
                        ,family = "binomial"
                        ,alpha = 0.5
                        ,max_iterations = 300
                        ,beta_epsilon = 0
                        ,lambda = 1e-05
                        ,lambda_search = FALSE
                        ,early_stopping = FALSE
                        ,nfolds = 0
                        ,seed = NULL
                        ,intercept = TRUE
                        ,gradient_epsilon = -1
                        ,remove_collinear_columns = FALSE
                        ,max_runtime_secs = 10000
                        ,missing_values_handling = c("Skip"))

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
# Model Key:  GLM_model_R_1484053333586_1 
# GLM Model: summary
# family  link                              regularization number_of_predictors_total number_of_active_predictors number_of_iterations  training_frame
# 1 binomial logit Elastic Net (alpha = 0.5, lambda = 1.0E-5 )                        283                         272                    5 RTMP_sid_a6c9_1
# 
# H2OBinomialMetrics: glm
# ** Reported on training data. **
#   
#   MSE:  0.2098326
# RMSE:  0.4580749
# LogLoss:  0.607572
# Mean Per-Class Error:  0.3720209
# AUC:  0.7316312
# Gini:  0.4632623
# R^2:  0.1602123
# Null Deviance:  41328.6
# Residual Deviance:  36240.45
# AIC:  36786.45
# 
# Confusion Matrix for F1-optimal threshold:
#   NO   YES    Error          Rate
# NO     5418  9146 0.627987   =9146/14564
# YES    1771 13489 0.116055   =1771/15260
# Totals 7189 22635 0.366047  =10917/29824
# 
# Maximum Metrics: Maximum metrics at their respective thresholds
# metric threshold    value idx
# 1                       max f1  0.363651 0.711915 294
# 2                       max f2  0.085680 0.840380 389
# 3                 max f0point5  0.539735 0.683924 196
# 4                 max accuracy  0.521518 0.673887 207
# 5                max precision  0.987571 1.000000   0
# 6                   max recall  0.040200 1.000000 398
# 7              max specificity  0.987571 1.000000   0
# 8             max absolute_mcc  0.521518 0.348709 207
# 9   max min_per_class_accuracy  0.513103 0.672412 212
# 10 max mean_per_class_accuracy  0.521518 0.674326 207


# Get the variable importance of the models
h2o.varimp(airlines.glm)

# Standardized Coefficient Magnitudes: standardized coefficient magnitudes
# names coefficients sign
# 1 Origin.TLH     3.233673  NEG
# 2 Origin.CRP     2.998012  NEG
# 3 Origin.LIH     2.859198  NEG
# 4   Dest.LYH     2.766090  POS
# 5 Origin.KOA     2.461819  NEG
# 
# ---
#   names coefficients sign
# 278   Dest.JAN     0.000000  POS
# 279   Dest.LIT     0.000000  POS
# 280   Dest.SJU     0.000000  POS
# 281 Origin.LAN     0.000000  POS
# 282 Origin.SBN     0.000000  POS
# 283 Origin.SDF     0.000000  POS


# Predict using GLM model
pred = h2o.predict(object = airlines.glm, newdata = airlines.test)

# Look at summary of predictions: probability of TRUE class (p1)
summary(pred)

# predict   NO                YES              
# YES:9798  Min.   :0.01186   Min.   :0.02857  
# NO :3126  1st Qu.:0.33715   1st Qu.:0.37018  
# NA : 382  Median :0.48541   Median :0.51363  
#           Mean   :0.48780   Mean   :0.51220  
#           3rd Qu.:0.62886   3rd Qu.:0.66189  
#           Max.   :0.97143   Max.   :0.98814  
#           NA's   :382       NA's   :382 
 


# Construct a hyper-parameter space
alpha_opts = c(0,0.05,0.10,0.15,0.20,0.25,0.30,0.35,0.40,0.45,0.50,0.55,0.60,0.65,0.70,0.75,0.80,0.85,0.90,0.95,1)

# List of hyperparameters
hyper_params_opt = list(alpha = alpha_opts)

# Grid object with hyperparameters
glm_grid <- h2o.grid("glm"
                     ,grid_id = "glm_grid_1"
                     ,x=X
                     ,y=Y
                     ,training_frame=airlines.train
                     ,hyper_params = hyper_params_opt
                     ,family = "binomial")

# Sort grids by best performance (lower AUC). Little note: As we're dealing with classification
# in some probabilistc fashion, we'll use AUC as model selection metric.
# If the nature of the problem are cost sensitive (e.g. A delayed departure plane is much expensive for 
# the airport service than a delayed arrival) precision and recall can be the best choice
glm_sorted_grid <- h2o.getGrid(grid_id = "glm_grid_1", sort_by = "auc", decreasing = FALSE)

#Print the models
print(glm_sorted_grid)

# H2O Grid Details
# ================
#   
#   Grid ID: glm_grid_1 
# Used hyper parameters: 
#   -  alpha 
# Number of models: 21 
# Number of failed models: 0 
# 
# Hyper-Parameter Search Summary: ordered by increasing auc
# alpha          model_ids                auc
# 1 [D@4800a43e glm_grid_1_model_1 0.7076911403181928
# 2 [D@66030470 glm_grid_1_model_2 0.7122987232329416
# 3 [D@6a4a43d3 glm_grid_1_model_3 0.7145455620514375
# 4 [D@17604a1a glm_grid_1_model_4  0.715989429818657
# 5 [D@21e1e99f glm_grid_1_model_5 0.7169797604977775
#                
# ---
# alpha           model_ids                auc
# 16 [D@78833412 glm_grid_1_model_16  0.720595118360825
# 17 [D@44d770f2 glm_grid_1_model_17 0.7207086912177467
# 18 [D@31669527 glm_grid_1_model_18 0.7208228330257134
# 19 [D@5b376f34 glm_grid_1_model_19 0.7209144533220885
# 20 [D@6acad45e glm_grid_1_model_20 0.7209885192412766
# 21 [D@237ad7de  glm_grid_1_model_0 0.7240682725570593

# Grab the model_id based in AUC
best_glm_model_id <- glm_grid@model_ids[[1]]

# The best model
best_glm <- h2o.getModel(best_glm_model_id)

# Summary
summary(best_glm)

# Model Details:
#   ==============
#   
#   H2OBinomialModel: glm
# Model Key:  glm_grid_1_model_0 
# GLM Model: summary
# family  link             regularization number_of_predictors_total number_of_active_predictors number_of_iterations  training_frame
# 1 binomial logit Ridge ( lambda = 7.29E-5 )                        283                         282                    3 RTMP_sid_a6c9_1
# 
# H2OBinomialMetrics: glm
# ** Reported on training data. **
#   
#   MSE:  0.2121424
# RMSE:  0.4605891
# LogLoss:  0.612699
# Mean Per-Class Error:  0.3833898
# AUC:  0.7240683
# Gini:  0.4481365
# R^2:  0.1494395
# Null Deviance:  42448.59
# Residual Deviance:  37585.41
# AIC:  38151.41
# 
# Confusion Matrix for F1-optimal threshold:
#   NO   YES    Error          Rate
# NO     4993  9601 0.657873   =9601/14594
# YES    1751 14327 0.108907   =1751/16078
# Totals 6744 23928 0.370110  =11352/30672
# 
# Maximum Metrics: Maximum metrics at their respective thresholds
# metric threshold    value idx
# 1                       max f1  0.373247 0.716243 296
# 2                       max f2  0.105583 0.846435 391
# 3                 max f0point5  0.551991 0.685249 194
# 4                 max accuracy  0.513313 0.665949 218
# 5                max precision  0.980714 1.000000   0
# 6                   max recall  0.048978 1.000000 399
# 7              max specificity  0.980714 1.000000   0
# 8             max absolute_mcc  0.548278 0.332916 196
# 9   max min_per_class_accuracy  0.524282 0.664324 211
# 10 max mean_per_class_accuracy  0.548278 0.666166 196
# 
# Gains/Lift Table: Extract with `h2o.gainsLift(<model>, <data>)` or `h2o.gainsLift(<model>, valid=<T/F>, xval=<T/F>)`
# 
# 
# 
# Scoring History: 
#   timestamp   duration iteration negative_log_likelihood objective
# 1 2017-01-10 11:11:07  0.000 sec         0             21224.29620   0.69198
# 2 2017-01-10 11:11:07  0.066 sec         1             18857.11178   0.61705
# 3 2017-01-10 11:11:07  0.094 sec         2             18795.11788   0.61562
# 4 2017-01-10 11:11:07  0.126 sec         3             18792.70362   0.61559
# 
# Variable Importances: (Extract with `h2o.varimp`) 
# =================================================
#   
#   Standardized Coefficient Magnitudes: standardized coefficient magnitudes
# names coefficients sign
# 1 Origin.MDW     1.915481  POS
# 2 Origin.HNL     1.709757  NEG
# 3 Origin.LIH     1.584259  NEG
# 4 Origin.HPN     1.476562  POS
# 5 Origin.AUS     1.439134  NEG
# 
# ---
#   names coefficients sign
# 278 Origin.PHX     0.009111  POS
# 279   Dest.PWM     0.008332  POS
# 280 Origin.GEG     0.008087  POS
# 281   Dest.BOS     0.005105  POS
# 282   Dest.MCI     0.003921  NEG
# 283   Dest.CHA     0.000000  POS

# Get model and put inside a object
model = best_glm

# Prediction using the best model
pred2 = h2o.predict(object = model, newdata = airlines.test)

# Summary of the best model
summary(pred2)

# predict    NO                YES              
# YES:10368  Min.   :0.01708   Min.   :0.05032  
# NO : 2938  1st Qu.:0.33510   1st Qu.:0.39258  
#            Median :0.47126   Median :0.52781  
#            Mean   :0.47526   Mean   :0.52474  
#            3rd Qu.:0.60648   3rd Qu.:0.66397  
#            Max.   :0.94968   Max.   :0.98292  


# Shutdown the cluster 
h2o.shutdown()

# Are you sure you want to shutdown the H2O instance running at http://localhost:54321/ (Y/N)? Y
# [1] TRUE

