# Attrition Analysis using GLM

#Install Main packages
install.packages("glm2")
install.packages("aod")
install.packages("pROC")
install.packages("Deducer")
install.packages("ROCR")

install.packages("ggplot2")
install.packages("JGR")
install.packages("rJava")
install.packages("JavaGD")
install.packages("iplots")

#Calls all functions
library(glm2)
library(aod)
library(pROC)
library(ROCR)

library(ggplot2)
library(JGR)
library(rJava)
library(JavaGD)
library(iplots)



# Loading data into memory
NdL <- read.csv("/Users/flavioclesio/Desktop/NdL_201508.csv")

# Convert churn variable to factor (categorical)
NdL$churned <- factor(NdL$churned)

#Convert other variables
NdL$area <- factor(NdL$area)
NdL$subscription_id <- factor(NdL$subscription_id)
NdL$configuration_id <- factor(NdL$configuration_id)
NdL$application_id <- factor(NdL$application_id)
NdL$subscription_status_id <- factor(NdL$subscription_status_id)
NdL$creation_date <- as.Date(NdL$creation_date)
NdL$created_as_free_user <- factor(NdL$created_as_free_user)
NdL$active_date <- as.Date(NdL$active_date)
NdL$renew_count <- factor(NdL$renew_count)
NdL$last_successfully_transaction <- as.Date(NdL$last_successfully_transaction)
NdL$has_billed <- factor(NdL$has_billed)
NdL$reference_id <- factor(NdL$reference_id)
NdL$charge_id <- factor(NdL$charge_id)
NdL$last_renew_attempt <- as.Date(NdL$last_renew_attempt)
NdL$user_plan <- factor(NdL$user_plan)
NdL$optin <- factor(NdL$optin)
NdL$ad_partner_original <- factor(NdL$ad_partner_original)
NdL$ad_detail_original <- factor(NdL$ad_detail_original)




# Fitting Generalized Linear Model to the data
NdL_fitlogit <- glm(formula = churned ~ Gender + Age + Income + FamilySize + Education + 
                       Calls + Visits, family = "binomial", data = attrdata)
                   
# Summerizing results
summary(fitlogit)




# Analysis of variances
round(x = anova(fitlogit), digits = 4)

# Variance - Covariance table
round(x = vcov(fitlogit), digits = 4)

# Coefficient of variables in fitted model
round(x = coef(fitlogit), digits = 4)

# Confidence Intervals using standard errors in the test
round(x = confint.default(fitlogit), digits = 4)

# Calculating odds ratios for the variables
round(x = exp(coef(fitlogit)), digits = 4)

## Calculating odds ratios with 95% confidence interval
round(x = exp(cbind(OR = coef(fitlogit), confint(fitlogit))), digits = 4)

# Storing predicted probabilities for GLM fits in an additional column "prob" in our dataframe
attrdata$prob <- NA


PredProb=predict(fitlogit,type='response') #predicting probabilities





wald.test(b=coef(fitlogit), Sigma=vcov(fitlogit), Terms=4:6)


# Plotting probabilities of churning a customer in the dataset


## Area under the curve: 0.842 (which represents that the model is very good, if not excellent!)

modelfit <- roc.formula(formula = Churn ~ prob, data = attrdata)

# Clearly the graph of ROC curve and the Area Under Curve (AUC) value confirm the "very good predictive model".

# For reference, the following table represents some standards being followed by most researchers and analysts:
# AUC value    Model
#   0.5        No distinguish ability shown by the prediction model develoved and required further improvements
#   0.5-0.7    Although can be accepted but overall it is not a very good model
#   0.7-0.9    very good prediction model (most models fall within this range)
#   0.9-1.0    Excellent Prediction Model (but are rare)


#   Using summary of Logistic Model and confirming the validity of model through various statistical tests, the following equation for prediction of churning is formed:

Probability of Churn = 1 / (1 + exp(-(-7.8365 - 0.0255 * Age + 0.0339 * Calls + 0.2227 * Education + 0.7869 * FamilySize + 1.333 * Gender + 1.4998 * Income + 0.4112 * Visits)))




