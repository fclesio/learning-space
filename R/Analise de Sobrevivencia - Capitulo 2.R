
#Estimador Kaplan-Meier com o valor de ??(t) constante entre os tempos de falha para 
# os grupos controle e ester??ide de dados de hepatite. Os tempos representados por + mostram 
# onde ocorreram censuras em cada grupo

require(survival)
tempos<- c(1,2,3,3,3,5,5,16,16,16,16,16,16,16,16,1,1,1,1,4,5,7,8,10,10,12,16,16,16)

cens<-c(0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0)

grupos<-c(rep(1,15),rep(2,14))

ekm<- survfit(Surv(tempos,cens)~grupos)

#Probabilidades de sobrevivencia, dado o time (nesse caso semanas) e a funcao survival (% em chances do evento de falha)
summary(ekm)

plot(ekm
     ,lty=c(2,1)
     ,xlab="Tempo (semanas)"
     ,ylab="S(t) estimada")


legend(1
       ,0.3
       ,lty=c(2,1)
       ,c("Controle","Ester??ide")
       ,lwd=1
       ,bty="n")


#Calculo do intervalo de confianca em estimadores Kaplan-Meier, atraves 
# de expressao de variancia assintotica, com intervalo de confianca em 95%.
ekm<- survfit(Surv(tempos,cens)~grupos,conf.type="plain")
summary(ekm)

#Utilizando a sugestao de Kalbfleish e Pretice (1980) em momentos em que forem utilizados
# valores extremos, e utilizada uma transformacao logaritmica para ??(t) 
ekm<- survfit(Surv(tempos,cens)~grupos,conf.type="log-log")
summary(ekm)

#Ajuste com o ajuste logaritmico
ekm<- survfit(Surv(tempos,cens)~grupos,conf.type="log")

#Fitting
ekm<- survfit(Surv(tempos,cens)~grupos)

#Estimativa de Nelson-Aalen
require(survival)

tempos<- c(1,2,3,3,3,5,5,16,16,16,16,16,16,16,16,1,1,1,1,4,5,7,8,10,10,12,16,16,16)

cens<-c(0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0)

grupos<-c(rep(1,15),rep(2,14))

ss<- survfit(coxph(Surv(tempos[grupos==2],cens[grupos==2])~1,method = "breslow"))

summary(ss)
racum<- -log(ss$surv)
racum


require(survival)

#Tempo em que reincidiu a volta do tumor s??lido em meses
tempos<- c(3,4,5.7,6.5,6.5,8.4,10,10,12,15)

#Censurado ou n??o (0 = censura)
cens<- c(1,0,0,1,1,0,1,0,1,1)

#Ajuste do modelo com uma funcao de sobrevivencia de kaplan-meier, 
# com intervalo de confianca de 95%
ekm<- survfit(Surv(tempos,cens)~1,conf.type="plain")

summary(ekm)

#Sobrevivencia e respectivos intervalos de 95% de confianca usando o estimador Kaplan-Meier
plot(ekm,conf.int=T,  xlab="Tempo (em meses)", ylab="S(t) estimada", bty="n")

#Calculo do tempo de vida estimado
t<- tempos[cens==1]

tj<-c(0,as.numeric(levels(as.factor(t))))

surv<-c(1,as.numeric(levels(as.factor(ekm$surv))))

surv<-sort(surv, decreasing=T)
k<-length(tj)-1

#Calculo do tempo de vida em meses, dado a funcao de sobrevivencia
prod<-matrix(0,k,1)
for(j in 1:k){
  prod[j]<-(tj[j+1]-tj[j])*surv[j]
}

tm<-sum(prod)

tm



require(survival)
tempos<- c(1,2,3,3,3,5,5,16,16,16,16,16,16,16,16,1,1,1,1,4,5,7,8,10,10,12,16,16,16)
cens<-c(0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0)
grupos<-c(rep(1,15),rep(2,14))
survdiff(Surv(tempos,cens)~grupos,rho=0)

tempos<-c(7,8,8,8,8,12,12,17,18,22,30,30,30,30,30,30,8,8,9,10,10,14,
          15,15,18,19,21,22,22,23,25,8,8,8,8,8,8,9,10,10,10,11,17,19)
cens<-c(rep(1,10), rep(0,6),rep(1,15),rep(1,13))
grupo<-c(rep(1,16), rep(2,15), rep(3,13))
require(survival)
ekm<-survfit(Surv(tempos,cens)~grupo)
summary(ekm)
plot(ekm, lty=c(1,4,2), xlab="Tempo",ylab="S(t) estimada")
legend(1,0.3,lty=c(1,4,2),c("Grupo 1","Grupo 2", "Grupo 3"),lwd=1,
       bty="n",cex=0.8)
survdiff(Surv(tempos,cens)~grupo,rho=0)
survdiff(Surv(tempos[1:31],cens[1:31])~grupo[1:31],rho=0)
survdiff(Surv(tempos[17:44],cens[17:44])~grupo[17:44],rho=0)
survdiff(Surv(c(tempos[1:16],tempos[32:44]),c(cens[1:16],
                                              cens[32:44]))~c(grupo[1:16],grupo[32:44]),rho=0)
