# Load data
pbc <- survival::pbc

# Survival Tree
pbc_stree <- rpart(Surv(time,status==2)~trt + age + sex + ascites + 
                     hepato + spiders + edema + bili + chol + albumin + 
                     copper + alk.phos + ast + trig + platelet + 
                     protime + stage,
                   pbc)
pbc_stree
pbc_stree$cptable
pbc_stree$variable.importance

windows(height=100,width=60)
plot(pbc_stree,uniform = TRUE)
text(pbc_stree,use.n=TRUE)

# Ensemble methods for survival data
pbc_rf <- rfsrc(Surv(time,status==2)~trt + age + sex + ascites + hepato + 
                  spiders + edema + bili + chol + albumin + copper + 
                  alk.phos + ast + trig + platelet + protime + stage,
                   ntree=500,tree.err = TRUE,
                   pbc)
pbc_rf$splitrule
pbc_rf$nodesize
pbc_rf$mtry
vimp(pbc_rf)$importance
var.select(pbc_rf, method = "vh.vimp", nrep = 50)
pdf("RandomForestSurvival_PBC.pdf")
plot(pbc_rf,plots.one.page = TRUE)
dev.off()

# Gradient Boosting for Survival Data
pbc_gbm <- gbm(Surv(time,status==2)~trt + age + sex + ascites + 
                 hepato + spiders + edema + bili + chol + albumin + 
                 copper + alk.phos + ast + trig + platelet + 
                 protime + stage,
               data=pbc)
  
