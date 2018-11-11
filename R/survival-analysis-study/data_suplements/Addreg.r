.First.lib<- function(lib,addreg)
{
#Written by:    Harald Fekjaer, <harald.fekjar@basalmed.uio.no>
  cat("Addreg 2, Beta 6.5 (2001-12-01) \n")
  cat(" 1996-2001, Harald Fekjaer & Odd O. Aalen, License: GNU version 2\n\n")
  cat("(Please register at http://www.med.uio.no/imb/stat/addreg/\n")
  cat(" so we can measure the interest for new versions.)\n\n")
  cat("Remark: This is a beta version without full documentation.\n\n")
}


addreg <- function(formula,data,starttime=NULL,stoptime = NULL, stopcond = 0.001, stand = F,testobs=T,estcovar=F,ridgereg=0) {
  # S-PLUS & R functions for analyses of surrviel analyses data with an additive hazard model.
  # Written by:	Harald Fekjaer, <harald.fekjar@basalmed.uio.no> & Odd O. Aalen etc.
  # See also:	http://www.med.uio.no/imb/stat/addreg/
  # License:	GNU version 2
  # Version:	2.0 Beta (2001-08-23), � 1996-2001
  #-----------Beginning of routine: -----------------  
 
  # We read data from formula notation:
  mf <- match.call()
  mf$starttime <- mf$stoptime <- mf$stopcond <- mf$stand <- mf$testobs <- mf$estcovar <- mf$ridgereg <- NULL
  mf[[1]] <- as.name("model.frame")
  mf <- eval(mf, sys.frame(sys.parent()))
  if (is.null(class(mf[, 1])) || !any(!is.na(match("Surv",class(mf[, 1])))))  
      stop("Response is not a survival object")
  if (attr(mf[, 1], "type") == "right") {
    mm <- model.matrix(formula, mf)
    covar <- data.matrix(mm) 
    time2  <- mf[, 1][, "time"]
    time   <- rep(0,length(time2))
    status <- mf[, 1][, "status"]    
  } else if (attr(mf[, 1], "type") == "counting") {
    mm <- model.matrix(formula, mf)
    covar <- data.matrix(mm) 
    time   <- mf[, 1][,1]
    time2  <- mf[, 1][,2]
    status <- mf[, 1][,3]    
  } else {
    stop("Addreg only accepts right-censored or counting processes data")
  } 

  # We handle posible missing data: 
  if ((prod(is.na(covar) == F) == 0) || (prod(is.na(time) == F) == 0) ||
       (prod(is.na(time2) == F) == 0) || (prod(is.na(status) == F) == 0)) {
    if (na.rm) {
      notmissing <- c(rep(1, times = dimcovar[1]))
      i <- 1
      for (i in 1:dimcovar[1]) {
        notmissing[i] <- prod(is.na(covar[i, ]) == F)
      }
      notmissing <- notmissing * (is.na(time) == F) * (is.na(time2) == F) * (is.na(status) == F)
      cat(dimcovar[1] - sum(notmissing), " observations ignored because of missing values\n")
      dimcovar[1] <- sum(notmissing)
      covar <- covar[notmissing == 1, ]
      trisk <- trisk[notmissing == 1]
      status <- status[notmissing == 1]
    } else { 
      stop("Missing not allowed unless na.rm=T\n\n")
    }
  }
  
  # We read Rige regression parameter:
  ridgeregexists <- ridgereg!=0
  if (ridgereg<0)
    stop("\"ridgereg\" must be >=0\n\n")
  
  # Some local variables etc.:
  nrint    <- length(time2)
  nrcovar  <- dim(covar)[2]
  covarnames <- dimnames(covar)[[2]] 
  cplace <- covarnames=="(Intercept)"
  if (sum(cplace)>0)
    covarnames[cplace] <- "Constant"
  
  # We standardize data:
  if (stand && attr(mf[, 1], "type") == "right" && (nrcovar>1)) {
      covar[,2:nrcovar] <- covar[,2:nrcovar]-t(matrix(rep(apply(covar[,2:nrcovar],2,mean),times=nrint),nrcovar-1))
  }
   
  #Sorting times and variables by time:
  covar  <- covar[order(time2),]
  status <- status[order(time2)]
  time   <- time[order(time2)]
  time2  <- sort(time2) 

  # Seting internal variables for use in estimation:
  increments <- matrix(0,nrint,nrcovar)
  if (testobs) {
   incretestobs    <- matrix(0,nrint,nrcovar)
   incretestobsvar <- matrix(0,nrint,nrcovar)
  }
  if (estcovar) {
    increcovar <- array(0,dim=c(nrint,nrcovar,nrcovar))
  }
  nrisk      <- rep(NA,nrint)
  id         <- matrix(0,nrint,nrint)
  ymatorg    <- data.matrix(covar)
  inull      <- matrix(0,nrint,nrint)
  stoped     <- F
  stopedtime <- NULL
  
  # For which values shall we estimate:
  calculate <- 1:nrint
  if (!is.null(starttime)) { 
    calculate <- calculate[time2>=starttime]
    firstused <- calculate[1]
  } else {
    firstused <- 1
  }
  if (!is.null(stoptime)) 
    calculate <- calculate[time2[calculate]<=stoptime]
  # We must use a loop in the estimating prosec:
  for(j in calculate) {
    ymat <- ymatorg
    notatrisk <- ((time>=time2[j])|(time2<time2[j])) 
        # Surv does not allow same time and time1, so we do include:
        # & (!(time==time2==time2[j])) 
    nrisk[j] <- sum(!notatrisk) 
    ymat[notatrisk,] <- 0
    # We standarize counting prosses data:
    if (attr(mf[, 1], "type") != "right") {
      nrcint <- sum(!notatrisk)
      if (nrcint>1 && stand) { 
        covarstand  <- ymat[!notatrisk,] 
        covarstand[,2:nrcovar] <- covarstand[,2:nrcovar]-t(matrix(rep(apply(covarstand[,2:nrcovar],2,mean),times=nrcint),nrcovar-1))
        ymat[!notatrisk,] <- covarstand 
      }
    }    
    # We find esimator:
    tyymat <- t(ymat) %*% ymat
    if (ridgeregexists) 
      tyymat <- tyymat + ridgereg*diag(nrcovar)
    absdet <- abs(prod(svd(tyymat, nu = 0, nv = 0)$d))
    if(absdet < stopcond) {
      cat("Remark: Stopped at time",time2[j],"because of too low rank.\n")
      cat("        (Last estimate at time ",time2[j-1],")\n",sep="")
      stoped     <- T
      stopedtime <- time2[j]
      lastused <- j - 1 
      break
    }
    if(status[j] == 1) {
      tyymatinv <- solve(tyymat)
      xmat <- tyymatinv %*% t(ymat)
      increments[j,] <- xmat[, j] 
      if (testobs) {  
        if (nrcovar>1) 
          kmat <- solve(diag(diag(tyymatinv)))
        else
          kmat <- 1/tyymatinv
        kmatx <- kmat %*% xmat
        incretestobs[j,] <- kmatx[,j]
        imat <- inull
        imat[j,j] <- 1
        incretestobsvar[j,]  <- diag(kmatx %*% imat %*% t(xmat) %*% kmat) 
      }
      if (estcovar) {
        imat <- inull
        imat[j,j] <- 1
        increcovar[j,,] <- xmat %*% imat %*% t(xmat)
      }
    }
  }
  
  # We find how many datapoints shall we use:
  if(!stoped) 
    lastused <- calculate[length(calculate)] 
  tused  <- calculate[calculate <=lastused]
  useest <- firstused:lastused
  
  # We make data for addreg-object:
  # Events used & events in datasett
  ntime <- c(sum(status[tused]),sum(status)) 
  # Times of events & cencoring
  times <- time2[firstused:lastused]		     
  # Increments of prosses (estimates)
  increments <- as.matrix(increments[firstused:lastused,])
  dimnames(increments) <- list(firstused:lastused,covarnames)
  # Number events
  nevent <- status[firstused:lastused]
  # Number events
  nrisk <- nrisk[firstused:lastused]
  # Increments for testobservator
  if (testobs) {
    incretestobs    <- as.matrix(incretestobs [firstused:lastused,])
    incretestobsvar <- as.matrix(incretestobsvar[firstused:lastused,])
  } else {
    incretestobs    <- NULL
    incretestobsvar <- NULL
  }
  # Increments of covariance:
  if (estcovar) {
    increcovar <- increcovar[firstused:lastused,,]
  } else {
    increcovar <- NULL
  }
  # Start point of estimation.
  if (is.null(starttime))
    startt <- 0
  else 
    startt <- starttime

  # We make object and return the result:
  res <- list(ntime=ntime,times=times,increments=increments,nevent=nevent,nrisk=nrisk,
              incretestobs=incretestobs, incretestobsvar=incretestobsvar,increcovar=increcovar,
              starttime=startt,stoped=stoped,stopedtime=stopedtime)
    # "stoped" (unchage) is indicator for "Stoped because of low rang"
    # "stopedtime" is the time estimation stoped ("time"="variable time").
  attr(res,"Call") <- sys.call()
  class(res) <- "addreg"
  return(res)
}

"plot.addreg" <-  function (addreg.object, variablenr = NULL,starttime = NULL, stoptime = NULL,
                            labelofvariable = NULL,jointies=0,xlab="Time",ylab ="Cumulative regression function") {
  
  # Seting some internal variabels:
  nint    <- length(addreg.object$times)
  nrcovar <- dim(addreg.object$increments)[2]
  if (is.null(starttime)) {
    startp <- addreg.object$starttime
  } else {
    startp <- starttime 
  }
  # Checking imput:
  if (!inherits(addreg.object, 'addreg')) 
    stop ("Must be an addreg object") 

  if (!is.null(starttime)) {
    if (addreg.object$times[nint] < starttime) {
      stop("Problem with variable starttime: Dataset don't include data for time",startime, "\n")
    }
  }

  if (!is.null(stoptime)) {
    if (addreg.object$starttime>stoptime) { 
      stop("Problem with variable stoptime: Dataset don't include data for time",stoptime, "\n")
    }
  }
  
  # Seting some default values:
  if (is.null(variablenr) == T) 
    variablenr <- 1:nrcovar -1
  if (is.null(labelofvariable)) 
    labelofvariable <- dimnames(addreg.object$increments)[[2]][variablenr+1]

  # Seting some more internal variabels:
  usevar     <- variablenr+1
  nrcovaruse <- length(variablenr)
   
  if (nrcovaruse>1) {
    # More than one plot are done with recursions 
    dimplot <- c(ceiling(sqrt(nrcovaruse)),ceiling(nrcovaruse/ceiling(sqrt(nrcovaruse))))
    save.par <- par("mfrow")
    on.exit(par(mfrow = save.par))
    par(mfrow = dimplot)
    for (i in 1:nrcovaruse) {
        plot.addreg(addreg.object,variablenr=variablenr[i],labelofvariable=labelofvariable[i],
                     ylab=ylab,xlab=xlab,starttime=starttime,stoptime=stoptime)
    }
    par(mfrow = c(1, 1))
  }
  else {
    # We calculate values & summerize data:
    if (is.null(starttime)) {
      startat <- 1
    } else { 
      startat <- sum(addreg.object$times<=starttime)
    }
    if (is.null(stoptime)) {
      stopat <- nint
    } else { 
      stopat <- sum(addreg.object$times<=stoptime)  
    }
    ptimes <- c(startp,addreg.object$times[startat:stopat])
    incre <- addreg.object$increments
    est <- c(0,cumsum(incre[startat:stopat,usevar]))
    se  <- c(0,sqrt(cumsum(incre[startat:stopat,usevar]^2)))
    
    # We calculate true endpoints:
    if (addreg.object$stoped) {
      estint <- c(addreg.object$starttime,addreg.object$stopedtime)
    } else {
      estint <- c(addreg.object$starttime,addreg.object$times[nint])
    }
    if (!is.null(starttime)) 
      estint[1] <- max(starttime,estint[1])     
      # We make sure that we don't plot outside estimation limits.
    if (!is.null(stoptime)) 
      estint[2] <- min(stoptime,estint[2])
    # We find last & first values
    nrpoints <- length(est)
    ptimes <- c(estint[1],ptimes,estint[2])
    est <- c(0,est,est[nrpoints])
    se  <- c(0,se,se[nrpoints])    
    
    # We remove posible ties:
    if (!is.null(jointies)) {
      notjoin <- (ptimes[2:nrpoints]-ptimes[1:(nrpoints-1)])>jointies
      notjoin <- c(F,notjoin)
      notjoin[length(notjoin)] <- F
      ptimes <- ptimes[notjoin]
      est    <- est[notjoin]
      se     <- se[notjoin]
    }
    
    # We find confidens intervals
    interval <- qnorm(.975)*se
    conf1 <- est+interval
    conf2 <- est-interval
    maxintval <- max(conf1)
    minintval <- min(conf2)
    # We plot data:
    plot(ptimes,est,type="s",xlab=xlab,ylab=ylab,ylim = c(minintval, maxintval))
    lines(ptimes,conf1,lty = 2,type="s")
    lines(ptimes,conf2,lty = 2,type="s")
    abline(h = c(0, 0), lty = 4)
    title(labelofvariable)
  }
}

"print.addreg" <-
function (addreg.object) 
{
  if (!inherits(addreg.object, 'addreg')) 
    stop ("Must be an addreg object")
    
  # We print information about object:  
  cat("Additive hazard regression fit (Aalen's model)\n")
  cat("  Variables:  ")
  cat(dimnames(addreg.object$increments)[[2]])
  cat("\n  Fitted at ")
  cat(addreg.object$ntime[1])
  nint <- length(addreg.object$times)
  cat(" time points until time", addreg.object$times[nint],"\n\n")
  cat("  Call: ")
  dput(attr(addreg.object, "Call"))
  cat("\n")
}

"summary.addreg" <-
function (addreg.object, esttime = NULL,testobs=NULL, digits = 3) 
{
  if (!inherits(addreg.object, 'addreg')) 
    stop ("Must be an addreg object")
  
  # We set local values and test imput data:
  nint    <- length(addreg.object$times)
  nrcovar <- dim(addreg.object$increments)[2]
  if (is.null(esttime)) { 
    esttime <- addreg.object$times[nint]
  }
  if ((esttime > addreg.object$times[nint])) 
      stop("Cannot estimate outside the range of the model.\n")
  if (is.null(testobs)) {
     testobs <- !is.null(addreg.object$incretestobs)
  } else if ((testobs) && is.na(addreg.object$incretestobs)) 
      stop("Object does not include testing data. Please run \"addreg\" again with \"testobs=T\".\n")

  # We calculate values & summerize data:
  estn  <- as.matrix(dimnames(addreg.object$increments)[[2]])
  incre <- as.matrix(addreg.object$increments[addreg.object$times<=esttime,])
  est <- apply(incre,2,sum)
  se  <- sqrt(apply(incre^2,2,sum))
  if (testobs) {
    incretobs  <- as.matrix(addreg.object$incretestobs[addreg.object$times<=esttime,])
    incretobsv <- as.matrix(addreg.object$incretestobsvar[addreg.object$times<=esttime,])
    teststat <- apply(incretobs,2,sum)/sqrt(apply(incretobsv,2,sum))
  }

  lconf <- est-qnorm(.975)*se
  hconf <- est+qnorm(.975)*se 
  
  # We print resulates:
  cat("Call: ")
  dput(attr(addreg.object, "Call"))
  cat("\n")
  cat("Additive hazard regression fit (Aalen's model)\n")
  cat("\n  Estimates at time ")
  cat(esttime)
  cat(":\n\n")
  if (testobs) {
    pvalue  <- 2 * (1 - pnorm(abs(teststat)))
    res <- matrix(c(est,se,lconf,hconf,teststat,pvalue),nrow=nrcovar)
    dimnames(res) <- list(estn,c("Coef.", "Std. Error", "  95%","C.I.  ","Test statistic","P-vaule"))
  } else {
    res <- matrix(c(est,se,lconf,hconf),nrow=nrcovar)
    dimnames(res) <- list(estn,c("Coef.", "Std. Error", "  95%","C.I.  "))  
  }
  prmatrix(round(res, digits))
  cat("\n")
  invisible(res)
}

