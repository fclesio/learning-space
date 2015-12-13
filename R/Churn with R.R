# For any firm in the world, attrition (churning) of its customers could be disastrous in the long term. Firms keep struggling in maintaining its customer base. 

# Analysts in customer relationship management department (in most firms) are taking advantages of modern tools available for continuously performing data mining and statistical analysis on the data available (in their databases). One of such data mining projects includes "Attrition analysis" (also known as "Churn Analysis") which is about developing a model to find the relations between customers' attrition and the variables that are causing it. 

# In fact in real world there could be hundreds (or may be thousands) of such variables which affects the attrition of customers. For example, price, service and product quality, advertising, competitors' promotions, distance of household, family structure, salary, disposable income, job security, taste change etc to name a few. Furthermore, there could be only quantitative variables or only qualitative variables or mix of both. In most cases, a mix of variables is seen to affect the decision of customer whether to stay with the existing brand or to leave (churn).

# In short, the goal of attrition analysis is to provide the mangers (of marketing or CRM department), the ability to understand which are those important variables that cause attrition and what is the likelihood of a customer to churn.

# Although attrition analysis models have specific requirements (e.g. finding the mix of important variables etc), in this tutorial I am using a binomial logistic as a predictive statistical model to analyze the variables and their contribution to the outcome (churn).

# I have a sample dataset which contains the outcome as binary event where value 1 stands for the event that customer churned (left) while 0 means the event that customer still is associated with that brand (or firm).

# The other variables that I am considering for this tutorials purposes are Customer's Gender, Age, Income, Family (household) size, Education (in number of years e.g. for under-graduate it is 16 years, of course it may be different in different countries), Calls (i.e. how many times, till date, customer has called to the service center or customer care department), Visits (i.e. how many times customer has visited to the local service center till date)

# You can download the sample dataset in CSV format from this link:
# Download Sample Dataset HERE
# or from my box.net link: https://app.box.com/s/fb75bd1yecuvv2jlk4qx


#Install package to fit GML
install.packages("glm2")
install.packages("aod")
install.packages("pROC")
install.packages("Deducer")


#Invoke the library
library(glm2)
library(aod)
library(pROC)
library(Deducer)

#Load CSV file
attrdata <- read.csv("http://idatasciencer.com/files/attrition.csv")

fitlogit <- glm(formula = Churn ~ Gender + Age + Income + FamilySize + Education + 
           Calls + Visits, family = "binomial", data = attrdata)
       
# Fitting Generalized Linear Model to the data
fitlogit 

# Summerizing results
summary(fitlogit)

# Analysis of variances
round(x = anova(fitlogit), digits = 4)

# Variance - Covariance table
round(x = vcov(fitlogit), digits = 4)

# Coefficient of variables in fitted model
round(x = coef(fitlogit), digits = 4)

# Confidence Intervals using profiled log-likelihood in the test
round(x = confint(fitlogit), digits = 4)

# Confidence Intervals using standard errors in the test
round(x = confint.default(fitlogit), digits = 4)

# Calculating odds ratios for the variables
round(x = exp(coef(fitlogit)), digits = 4)

## Calculating odds ratios with 95% confidence interval
round(x = exp(cbind(OR = coef(fitlogit), confint(fitlogit))), digits = 4)

# Storing predicted probabilities for GLM fits in an additional column "prob" in our dataframe
attrdata["prob"] <- NA


rocplot(prob)



modelfit<- groc.formula(formula = Churn ~ prob, data = attrdata)


# Plotting probabilities of churning a customer in the dataset


## 
## Call:
## roc.formula(formula = Churn ~ prob, data = attrdata)
## 
## Data: prob in 75 controls (Churn 0) < 85 cases (Churn 1).
## Area under the curve: 0.842 (which represents that the model is very good, if not excellent!)


# Plotting Area under Curve (AUC)
library(Deducer)
## Loading required package: ggplot2
## Loading required package: JGR
## Loading required package: rJava
## Loading required package: JavaGD
## Loading required package: iplots


modelfit


# Clearly the graph of ROC curve and the Area Under Curve (AUC) value confirm the "very good predictive model".

# For reference, the following table represents some standards being followed by most researchers and analysts:

# AUC value    Model
#   0.5        No distinguish ability shown by the prediction model develoved and required further improvements
#   0.5-0.7    Although can be accepted but overall it is not a very good model
#   0.7-0.9    very good prediction model (most models fall within this range)
#   0.9-1.0    Excellent Prediction Model (but are rare)



#   Using summary of Logistic Model and confirming the validity of model through various statistical tests, the following equation for prediction of churning is formed:

Probability of Churn = 1 / (1 + exp(-(-7.8365 - 0.0255 * Age + 0.0339 * Calls + 0.2227 * Education + 0.7869 * FamilySize + 1.333 * Gender + 1.4998 * Income + 0.4112 * Visits)))



This was one basic example of attrition analysis. In fact the real life examples could be very complex in nature.

I hope this would help learners to develop advanced skills in developing attrition analysis models for the firm and, hence, can help further in management decision making.