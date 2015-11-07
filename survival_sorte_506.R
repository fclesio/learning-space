
library(survival)


sorte_506 <- read.csv('/Users/flavioclesio/Documents/Github/learning-space/survival_analysis_5_506.csv')

head(sorte_506)

summary(sorte_506)


sorte_506$survival <- Surv(sorte_506$survival_days, sorte_506$churned == 1)

fit <- survfit(survival ~ 1, data = sorte_506)

plot(fit, lty = 1, mark.time = TRUE, xlim=c(1,90), ylim=c(.00,1), xlab = 'Dias desde a assinatura', ylab = '% Clientes Retidos')
title(main = 'Curva de Retenção do Sorte')