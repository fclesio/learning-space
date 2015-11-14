#Logit Regression Template

#Original Link: http://www.ats.ucla.edu/stat/r/dae/logit.htm

#Load packgaes
library(aod)
library(ggplot2)

mydata <- read.csv("http://www.ats.ucla.edu/stat/data/binary.csv")
## view the first few rows of the data
head(mydata)

summary(mydata)

sapply(mydata, sd)


## two-way contingency table of categorical outcome and predictors we want
## to make sure there are not 0 cells
xtabs(~admit + rank, data = mydata)


mydata$rank <- factor(mydata$rank)
mylogit <- glm(admit ~ gre + gpa + rank, data = mydata, family = "binomial")



summary(mylogit)


## interpretation
       
      # For every one unit change in gre, the log odds of admission (versus non-admission) increases by 0.002.
      # For a one unit increase in gpa, the log odds of being admitted to graduate school increases by 0.804.
      # The indicator variables for rank have a slightly different interpretation. For example, having attended an undergraduate institution with rank of 2, versus an institution with a rank of 1, changes the log odds of admission by -0.675.


## CIs using profiled log-likelihood
confint(mylogit)


## CIs using standard errors
confint.default(mylogit)


wald.test(b = coef(mylogit), Sigma = vcov(mylogit), Terms = 4:6)


## odds ratios only
exp(coef(mylogit))


## odds ratios and 95% CI
exp(cbind(OR = coef(mylogit), confint(mylogit)))


## Interpretation
      # for a one unit increase in gpa, the odds of being admitted to graduate school
      # (versus not being admitted) increase by a factor of 2.23. 


newdata1 <- with(mydata, data.frame(gre = mean(gre), gpa = mean(gpa), rank = factor(1:4)))

## view data frame
newdata1


newdata1$rankP <- predict(mylogit, newdata = newdata1, type = "response")
newdata1


#Interpretation

      # predicted probability of being accepted into a graduate program is 0.52 for 
      # students from the highest prestige undergraduate institutions (rank=1), 
      # and 0.18 for students from the lowest ranked institutions (rank=4), 
      # holding gre and gpa at their means. 


newdata2 <- with(mydata, data.frame(gre = rep(seq(from = 200, to = 800, length.out = 100),
                                              4), gpa = mean(gpa), rank = factor(rep(1:4, each = 100))))




newdata3 <- cbind(newdata2, predict(mylogit, newdata = newdata2, type = "link",
                                    se = TRUE))
newdata3 <- within(newdata3, {
  PredictedProb <- plogis(fit)
  LL <- plogis(fit - (1.96 * se.fit))
  UL <- plogis(fit + (1.96 * se.fit))
})

## view first few rows of final dataset
head(newdata3)



ggplot(newdata3, aes(x = gre, y = PredictedProb)) + geom_ribbon(aes(ymin = LL,
                                                                    ymax = UL, fill = rank), alpha = 0.2) + geom_line(aes(colour = rank),
                                                                                                                      size = 1)