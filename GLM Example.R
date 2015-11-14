#Template GLM 

#Original Link: http://www.ats.ucla.edu/stat/r/dae/probit.htm

#Load libraries
library(aod)
library(ggplot2)

# Example 2: A researcher is interested in how variables, 
# such as GRE (Graduate Record Exam scores), GPA (grade point average) 
# and prestige of the undergraduate institution, effect admission into graduate school.
# The response variable, admit/don't admit, is a binary variable.

#Load data
mydata <- read.csv("http://www.ats.ucla.edu/stat/data/binary.csv")

## convert rank to a factor (categorical variable)
mydata$rank <- factor(mydata$rank)

## view first few rows
head(mydata)

##Cross-tabbing
xtabs(~ rank + admit, data = mydata)

## We'll use the myprobit variable to store the model 
myprobit <- glm(admit ~ gre + gpa + rank, family=binomial(link="probit"), data=mydata)

#Summary of the GLM model
summary(myprobit)

## Interpretation
      # For a one unit increase in gre, the z-score increases by 0.001.
      # For each one unit increase in gpa, the z-score increases by 0.478.
      # The indicator variables for rank have a slightly different interpretation. For example, having attended an undergraduate institution of rank of 2, versus an institution with a rank of 1 (the reference group), decreases the z-score by 0.415.

## Shows confidence intervals for the coefficient estimates
confint(myprobit)

## Make the Wald test
wald.test(b=coef(myprobit), Sigma=vcov(myprobit), Terms=4:6)

## Interpretation
      # The chi-squared test statistic of 21.4 with three degrees of freedom is 
      # associated with a p-value of less than 0.001 indicating that the overall
      # effect of rank is statistically significant.


#Predicting Probabilities

#New dataframe with spare data
newdata <- data.frame(
  gre = rep(seq(from = 200, to = 800, length.out = 100), 4 * 4),
  gpa = rep(c(2.5, 3, 3.5, 4), each = 100 * 4),
  rank = factor(rep(rep(1:4, each = 100), 4)))

#New file
head(newdata)

#Input predictions 
newdata[, c("p", "se")] <- predict(myprobit, newdata, type = "response", se.fit=TRUE)[-3]

#p = Probability, se = Standard Error

#Plot probabilities
ggplot(newdata, aes(x = gre, y = p, colour = rank)) +
  geom_line() +
  facet_wrap(~gpa)


## change in deviance
with(myprobit, null.deviance - deviance)

## change in degrees of freedom
with(myprobit, df.null - df.residual)

## chi square test p-value
with(myprobit, pchisq(null.deviance - deviance,
                      df.null - df.residual, lower.tail = FALSE))

logLik(myprobit)

