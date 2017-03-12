
# Technical Reference: http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2410013/ 
library(survival)

ch <- read.csv("/Users/flavio.clesio/Documents/Github/learning-space/Datasets/competing_risks.csv")

# Multistate type
ch$survival <- Surv(ch$time, ch$event * ch$type, type = 'mstate')

# Surv function
fit <- survfit(survival ~ 1, data = ch)

plot(fit
     , mark.time = FALSE
     , col = c('red', 'blue')
     , xlab = 'Days Since Subscribing'
     , ylab = '% Experiencing Event')

title('Cumulative Incidence of 2 Hazards')

legend(x = 0
       , y = .2
       , col = c('red', 'blue')
       , legend = c('Churn', 'Upgrade')
       , lty = c(1, 1))