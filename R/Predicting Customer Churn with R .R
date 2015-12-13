# 20140407
#
# try and replicate Eric Chiang's Python code of churn model published at 
# http://blog.yhathq.com/posts/predicting-customer-churn-with-sklearn.html

install.packages("e1071")
install.packages("FNN")
install.packages("randomForest")
install.packages("data.table")
install.packages("ggplot2")



## @knitr prep
# main settings: clean up, set output options, require libraries
library(e1071)        # for SVM
library(FNN)          # for faster KNN than class::knn
library(randomForest) # for RF
library(data.table)
library(ggplot2)

data <- read.csv('https://raw.githubusercontent.com/EricChiang/churn/master/data/churn.csv')

# dependent variable
y <- data$Churn.=='True.'

# now set covariates
X <- subset(data,select=-c(State,Area.Code,Phone,Churn.))
X[c('Int.l.Plan','VMail.Plan')] <- X[c('Int.l.Plan','VMail.Plan')]=='yes'
X.scaled <- scale(X)

## @knitr runandcompare
# compare 3 classifiers with k-fold cross-validation
modelBakeOff <- function(k=5) {
  dat <- data.frame(X.scaled,y=as.factor(y))
  set.seed(20140407)
  folds=sample(rep(1:k,length=nrow(dat)))
  
  # home of the accuracy rates
  acc   <- matrix(NA,k,3)
  
  # temporary homes of counts for confusion matrices
  cmsvm <- list()
  cmrf  <- list()
  cmknn <- list()
  
  # temporary homes for probability tables
  probsvm <- list()
  probrf  <- list()
  probknn <- list()
  
  # try some classifiers, as close as I can get them to sklearn defaults
  for(j in 1:k) {
    # SVM classifier
    svmfit <- svm(y~.,data=dat[folds!=j,],kernel="radial",scale=FALSE,probability=TRUE)
    svmprob <- predict(svmfit, newdata=dat[folds==j,], probability=TRUE)
    acc[j,1] <- sum(svmprob==dat[folds==j,]$y)/nrow(dat[folds==j,])
    cmsvm[[j]] <- table(svmprob,dat[folds==j,]$y)
    probsvm[[j]] <- cbind(as.logical(dat[folds==j,]$y),as.logical(svmprob),attr(svmprob,'probabilities')[,2])
    
    # randomForest
    train  <- folds!=j
    rffit  <- randomForest(y~.,data=dat,subset=train,ntree=10)
    rfprob <- predict(rffit,dat[folds==j,],type='prob')
    acc[j,2] <- sum((rfprob[,2]>.5)==(as.logical(dat[folds==j,]$y)))/nrow(dat[folds==j,])
    cmrf[[j]] <- table(rfprob[,2]>.5,dat[folds==j,]$y)
    probrf[[j]] <- cbind(as.logical(dat[folds==j,]$y),rfprob[,2]>.5,rfprob[,2])
    
    # K-nearest neighbors
    knnfit <- knn(X.scaled[folds!=j,],X.scaled[folds==j,],cl=factor(y)[folds!=j],k=5,prob=TRUE)
    acc[j,3] <- sum(knnfit==factor(y)[folds==j])/length(knnfit)
    cmknn[[j]] <- table(knnfit,dat[folds==j,]$y)
    probknn[[j]] <- cbind(as.logical(dat[folds==j,]$y),as.logical(knnfit),attr(knnfit,'prob'))
  }
  colnames(acc) <- c('SVM','rF','KNN')
  
  # now add the k tables together for full 
  # cross-validated confusion matrices
  makeCM <- function(x) {
    out <- Reduce('+',x)
    dimnames(out)[[1]] <- paste('predicted',dimnames(out)[[1]],sep='.')
    return(out)
  }
  cmsvm <- makeCM(cmsvm)
  cmrf  <- makeCM(cmrf)
  cmknn <- makeCM(cmknn)
  
  # now rbind() together the k probability matrices
  # for full cross-validated probability estimates
  probsvm <- Reduce("rbind",probsvm)
  probrf  <- Reduce("rbind",probrf)
  probknn <- Reduce("rbind",probknn)    
  
  cm          <- list(cmsvm,cmrf,cmknn)
  prob        <- list(probsvm,probrf,probknn)
  names(cm)   <- colnames(acc)
  names(prob) <- colnames(acc)
  
  out <- list(acc,cm,prob)
  names(out) <- c('CV Accuracy','CV Confusion Matrices','CV Probabilities')
  return(out)
}
bakeoff <- modelBakeOff()

# OK, so now I have predicted probabilities for everybody. Let's 
# split data into groups corresponding to probability ranges.
# This function takes a probability matrix (pm) as stored in
# the third element of the list that modelBakeoff() returns.
# this will be useful for several things later:
groupThese <- function(pm,k=10) {
  ranges <- c(0,c(1:k)/k)
  df <- data.frame(c(1:nrow(pm)),pm)
  names(df) <- c('id','true.churn','predicted.churn','prob')
  df$group  <- NA
  for(i in 1:k) {
    df$group[df$prob<=ranges[i+1] & df$prob>ranges[i]] <- i
  }
  dt <- data.table(df)
  setkey(dt,group,id)
  return(dt)
}    

# function below takes a data table as returned by groupThese().
# it returns a list of three things:
# 1. summary -- a data table that summarizes frequency counts, empirical
#    probabilities (true and predicted) within each bin of estimated probabilities.
# 2. cscore -- a calibration score
# 3. dscore -- a discrimination score
summarizeThese <- function(dt) {
  summary <- dt[,list(trueprobs=mean(true.churn),predprobs=mean(prob),count=.N),by=list(group)]
  baseprob <- summary$trueprobs %*% summary$count / sum(summary$count)
  cscore   <- (summary$trueprobs-summary$predprobs)^2 %*% summary$count / sum(summary$count)
  dscore   <- (summary$trueprobs-baseprob)^2 %*% summary$count / sum(summary$count)    
  out <- list(summary,cscore,dscore)
  names(out) <- c('summary','calibration','discrimination')
  return(out)
}

svmsum <- summarizeThese(groupThese(bakeoff[[3]][['SVM']]))
rfsum  <- summarizeThese(groupThese(bakeoff[[3]][['rF']]))
knnsum <- summarizeThese(groupThese(bakeoff[[3]][['KNN']]))

## @knitr accuracy
# Cross-validated accuracy rates
round(colMeans(bakeoff[[1]]),3)

## @knitr confusion
# Cross-validated confusion matrices
bakeoff[[2]]

## @knitr pictures
# now GGplot
baseprob <- rfsum[[1]]$trueprobs %*% rfsum[[1]]$count / sum(rfsum[[1]]$count)
theme_set(theme_gray(base_size = 18))
psvm <- ggplot(svmsum[[1]],aes(predprobs,trueprobs)) + geom_point(aes(size=count)) + 
  geom_line(colour='darkred',aes(y=predprobs)) + ylab('Observed churn rates') +
  geom_line(colour='darkgreen',aes(y=baseprob)) + 
  xlab('Predicted probability ranges') + scale_size_continuous(range = c(3, 8)) + 
  ggtitle(expression(atop("SVM diagnostic plot", atop("red line is perfect prediction; bubble sizes proportional to observations in each group", ""))))

prf <- ggplot(rfsum[[1]],aes(predprobs,trueprobs)) + geom_point(aes(size=count)) + 
  geom_line(colour='darkred',aes(y=predprobs)) + ylab('Observed churn rates') +
  geom_line(colour='darkgreen',aes(y=baseprob)) +     
  xlab('Predicted probability ranges') + scale_size_continuous(range = c(3, 8)) + 
  ggtitle(expression(atop("randomForest diagnostic plot", atop("red line is perfect prediction; bubble sizes proportional to observations in each group", ""))))

## @knitr cdscores
# More diagnostics: calibration and discrimination
cdscores <- matrix(c(svmsum[[2]],svmsum[[3]],rfsum[[2]],rfsum[[3]],knnsum[[2]],knnsum[[3]]),ncol=3,dimnames=list(c('Calibration','Discrimination'),c('SVM','rF','KNN')))
print(round(cdscores,3))

