############################################################
#Livro: Analise de Sobrevivencia Aplicada			
#Autores: Enrico Antonio Colosimo e Suely Ruiz Giolo	
#E-mail autores: enricoc@est.ufmg.br &  giolo@ufpr.br
#Editora: Edgar Blucher	(www.blucher.com.br)					
#Ano Publicacao: 2006 	Edicao: 1a.
############################################################

#########################
#Cap??tulo 1 - Introducao
#########################

#Censura = Observa????o parcial da resposta

#Na analise de sobrevivencia a resposta sempre sera longituginal, que pode ser observacional 
#ou experimental.

#As 4 formas de estudos clinicos sao:
# 1. Descritivo (Observacional)
# 2. Caso Controle (Observacional)
# 3. Coorte (Observacional)
# 4. Clinico Randomizado (Experimental)

# Os dados de sobrevivencia sao caracterizados por 2 aspectos
# 1. Censura
# 2. Tempo de falha
#  - Tempo inicial
#  - Escala de medida
#  - Evento de interesse

# A censura pode ter 2 classificacoes
#  - Censura Tipo I: O estudo sera terminado ap??s um periodo de tempo
#  - Censura Tipo II: Termina quando o evento de interesse ocorre com um n??mero pre-estabelecido de individuos

# Tipos de censura
# Censura a direita: O evento de interesse esta a direita do tempo registrado (e.g. criancas que nao sabiam ler ate o inicio do estudo) 
# Censura a esquerda: O evento de interesse e maior que o tempo de falha (e.g. criancas que sabiam ler antes do inicio do estudo mas nao sabem a data exata)

# O Truncamento e uma caracteristica que exclui os individuos do estudo, i.e. eles nao sao 
# acompanhados desde o inicio do estudo, mas sim quando desenvolvolvem a variavel de interesse

# As duas colunas obrigatorias para o analise de sobrevivencia sao a) se ocorreu um tempo de falha, 
# e b) se o tempo foi censurado

# Aspectos que diferenciam a analise de sobrevivencia das tecnicas 
# estatisticas convencionais:
# a. Presenca de censuras nos dados
# b. Truncamento dos dados
# c. Comparabilidade nos tratamentos e dos pontos de dados ao longo do tempo

#Funcao de sobrevivencia: 

# S(t) = P(T>=t)

# S(t) = Funcao de sobrevivencia
# P = Probabilidade
# T = Variavel aleatoria nao negativa
# t = tempo

#Funcao de distribuicao acumulada (Probabilidade de uma observacao nao sobreviver ao tempo t)

# F(t) = 1 - S(t)

# F(t) = Funcao de distribuicao
# S(t) = Funcao de sobrevivencia

# Funcao de Taxa de Falha (Probabilidade de falha em um periodo entre S(t1) - S(t2))
# ??(t) = lim ??t->0 P(t<= T < t+ ??t|T>=t)/??t


#########################################
#Cap??tulo 2 - Tecnicas Nao parametricas
#########################################

# Uma das caracteristicas da analise de sobrevivencia, e que em sua modelagem a presenca
# de censuras e totalmente previsivel, e tambem diferente das tecnicas convencionais como media
# desvio padrao e demais tecnicas de estatistica descritiva (avaliacao de medidas
# de tendencia central e variabilidade), ao inves de estimar-se por todos
# os dados presentes, e feita a funcao de sobrevivencia para relacionar o tempo de vida e o
# tempo de falha, considerando que os dados censurados constituem parte da informacao dessa
# funcao.

# A estimacao na ausencia de censura e dada pela seguinte formula

# ??([Nr Falhas no Periodo, Nr que nao falharam ate t]) = ??Falhas / ??Sem Falhas
 
# ??Falhas = Nr Falhas no Periodo
# ??Sem Falhas = Nr que nao falharam ate t

# Essa formula acima, parte do principio que o evento de interesse (nesse caso de falha)
# ocorreu em 100% dos pacientes, o que em um cenario de avaliacao em que temos dados censurados
# nao e factivel.

# Dessa forma, s??o usados estimadores de funcao de sobrevivencia.
# Um desses estimadores tem o nome de Kaplan-Meier (EKM) que tem como caracteristica nao ser parametrico
# e e chamado tambem de estimador limite-produto

# SKM(t) = 1-(ti/ni) = (ni-di)/ni

# ti = Nr de eventos terminais ocorridos em ti
# ni = Nr de individuos que poderiam ser atingidos por pelo evento terminal, i.e.
# Individuos em risco no intervalo ti que nao falharam e nao foram censurados ate
# o instante ti anterior.

#Start Run(Fun)time
  
  #Chamada do pacote
  require(survival)
  
  #Pacientes com hepatite, e o total de semanas que participou do estudo
  tempos<- c(1,2,3,3,3,5,5,16,16,16,16,16,16,16,16,1,1,1,1,4,5,7,8,10,10,12,16,16,16)
  
  # Informacoes sobre se o paciente teve o tratamento/acompanhamento interrompido (censura)
  cens<-c(0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0)
  
  grupos<-c(rep(1,15),rep(2,14))
  
  #Uso da funcao de sbrevivencia, usando o estimador Kaplan-Meier (default) em um objeto chamado" ekm"
  ekm<- survfit(Surv(tempos,cens)~grupos)
  
  #Informacoes basicas sobre o objeto
  summary(ekm)
  
  #Plotagem do gr??fico 
  plot(ekm
       ,lty=c(2,1)
       ,xlab="Tempo (semanas)"
       ,ylab="S(t) estimada")
  
  legend(1,0.3
         ,lty=c(2,1)
         ,c("Controle","Esteroide")
         ,lwd=1
         , bty="n")

  # Das informacoes sobre o objeto, temos as seguintes propriedades:
    
        # time = momento tempo dentro do estudo
        # n.risk = individuos em risco no momento (time) indicado
        # n.event = Numero de falhas (mortes) no momento (time) indicado
        # survival = probabilidade de morte do individuo no tempo t, 
        #           sendo que ele nao morreu no intervalo imediatamente anterior | S(ti+)
        # std.err = Erro padrao da probabilidade de sobrevivencia 
        # lower 95% CI =  Menor intervalor com 95% de confianca 
        # upper 95% CI = Maior intervalo com 95% de confianca  
    
  
  # Obtencao de um intervalo de confianca dentro de uma distribuicao assintotica normal
  ekm<- survfit(Surv(tempos,cens)~grupos,conf.type="plain")
  summary(ekm)
  
  # Quando o intervalo de confianca passar do limite de 1, ou mesmo assumir um valor negativo
  # uma transformacao logaritmica em S(t) deve ser feita assim como assevera o trabalho de 
  # Kalbfleish e Pretice (1980) na estimativa de variancia assintotica. Os seguintes comando serve
  # para obter essa estimativa
  ekm<- survfit(Surv(tempos,cens)~grupos,conf.type="log-log")
  summary(ekm)
  
  ekm<- survfit(Surv(tempos,cens)~grupos,conf.type="log")
  ekm<- survfit(Surv(tempos,cens)~grupos)

#End Run(Fun)time

  
  
# Um estimador usado para analise nao-parametrica e o Nelson-Aalen (1978).
# A caracteristica desse estimador e que ele trabalha com uma funcao de risco
# acumulada, baseado na seguinte formula:
  
# S(t) =  exp{-??(t)}  
  
# Sendo que ?? ?? definido como a taxa de falha
  
# A equacao para a formula de Nelson-Aalen e definida como:
  
# ??(t) = ??(di/ni) em que:  

  # di = Nr de eventos terminais ocorridos em ti
  # ni = Nr de individuos que poderiam ser atingidos por pelo evento terminal, i.e.
  # Individuos em risco no intervalo ti que nao falharam e nao foram censurados ate
  # o instante ti anterior.    
  
#Start Run(Fun)time
  #Estimativa de sobrevivencia utilizando a funcao de Nelson-Aalen
  
  #Chamada do pacote de sobrevivencia
  require(survival)
  
  #Indicacao de cada um dos 29 pacientes e o respectivo tempo de acompanhamento
  tempos<- c(1,2,3,3,3,5,5,16,16,16,16,16,16,16,16,1,1,1,1,4,5,7,8,10,10,12,16,16,16)
  
  #Informacao de censura de cada um dos pacientes
  cens<-c(0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0)

  grupos<-c(rep(1,15),rep(2,14))
  
  #Chamada da funcao de sobrevivencia
  ss<- survfit(coxph(Surv(tempos[grupos==2],cens[grupos==2])~1,method = "breslow"))
  
  #Informacoes sobre os resultados da funcao
  summary(ss)
  
  #Atribuicao da variavel surv (probabilidade de sobrvivencia) no objeto racum  
  racum<- -log(ss$surv)
  
  #Informacoes de sobrevivencia para cada um dos pacientes no grupo
  racum
  
#End Run(Fun)time

  
# Uma informacao e que a funcao de taxa de falha ??(t) e que de acordo com o livro
# ela nao tem uma interpretacao probabilistica, mas sim utilidade na selecao de modelos.
# A comparacao entre os modelos Kaplan-Meier e Nelson-Aalen serve para ver qual tem o 
# melhor fitting de acordo com o conjunto de dados.
  
#Start Run(Fun)time  
  require(survival)
    
  #Pacientes com tumor solido  
  tempos<- c(3,4,5.7,6.5,6.5,8.4,10,10,12,15)
  
  #Reicidencia (Censura)
  cens<- c(1,0,0,1,1,0,1,0,1,1)
  
  #Estimador Kaplan-Meier, com intervalos de 95% de confianca
  ekm<- survfit(Surv(tempos,cens)~1,conf.type="plain")
  
  #Informacoes sobre o modelo e estimativas intervalares e pontuais
  summary(ekm)
  
  #S(t) = 
  #      1 se t <= 3
  #      0,900 se 3 < t <= 6,5
  #      0,643 se 6,5 < t <= 10
  #      0,482 se 10  < t <= 12
  #      0,241 se 12  < t <= 15
  #      0,000 se t > 15
  
  #Plotagem da funcao de sobrevivencia      
  plot(ekm
       ,conf.int=T
       ,xlab="Tempo (em meses)"
       ,ylab="S(t) estimada"
       ,bty="n")
  
  #Para o tempo mediano sendo obtido atraves de uma interpolacao linear
  
  # Busca-se somente os eventos de recorrencia (censura) do tumor
  t <- tempos[cens==1]
  
  # Ajuste da coluna como numerica
  tj <- c(0,as.numeric(levels(as.factor(t))))
  
  # Objeto 'surv' recebe as probabilidades de sobrevivencia do objeto ekm
  surv <- c(1,as.numeric(levels(as.factor(ekm$surv))))
  
  # Ordenacao do objeto de forma decrescente
  surv<-sort(surv, decreasing=T)
  
  #Objeto k recebendo o tamanho dos elementos no objeto tj com uma subtracao
  k <- length(tj)-1
  
  # Calculo do produto, em que na matriz, para cada coluna em k ha um produto de j
  # que recebe um objeto j +1 vezes a sua probabilidade de sobrevivencia.
  prod <- matrix(0,k,1)
  for(j in 1:k){
    prod[j] <- (tj[j+1]-tj[j])*surv[j]
  }
  
  #Produto da probabilidade
  tm<-sum(prod)
  
  #Tempo medio de vida estimado em meses
  tm

#End Run(Fun)time

  
# Um topico importante e em relacao a comparacao das curvas de sobrevivencia
# em que devem ser comparados o grupo de tratamento com o grupo de controle 
# utilizando todos os dados disponiveis. 

# Para generalizacao das estatisticas de sobrevivencia, h?? diversos testes como o 
# logrank, Wilcoxon, Monte Carlo, etc.
 
# O teste mais comum e o logrank, dado que ele se adequa muito bem em problemas que a 
# funcao de risco dos grupos e quase constante, em termos comparativos.

  
#Comparacao das curvas de sobrevivencia entre o grupo de tratamento com esteroides
# e o grupo de controle sem nenhuma posologia
  
#Start Run(Fun)time

  #Chamada do pacote  
  require(survival)
  
  #Pacientes com os respectivos tempos de acompanhamento    
  tempos<- c(1,2,3,3,3,5,5,16,16,16,16,16,16,16,16,1,1,1,1,4,5,7,8,10,10,12,16,16,16)
  
  #Recorrencia da doenca
  cens<-c(0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0)
  
  grupos<-c(rep(1,15),rep(2,14))
  
  #Funcao para ver as diferencas das curvas de sobrevivencia
  survdiff(Surv(tempos,cens)~grupos,rho=0)
  
  # T = 3.67
  # p = 0.0555 

#End Run(Fun)time


#Comparacoes de multiplas curvas de sobrevivencia  

#Start Run(Fun)time
  
  # 44 camondongos infectados com malaria  
  tempos<-c(7,8,8,8,8,12,12,17,18,22,30,30,30,30,30,30,8,8,9,10,10,14,
            15,15,18,19,21,22,22,23,25,8,8,8,8,8,8,9,10,10,10,11,17,19)

  # Atribuicao dos grupos de censura em 4 grupos. Grupo 1 (16), Grupo 2 (15), Grupo 3 (13)
  # Como o tempo de estudo foi de 30 dias, todos os camundongos que morreram depois de 30 dias
  # entraram em censura
  cens<-c(rep(1,10), rep(0,6),rep(1,15),rep(1,13))

  #Atribuicao dos grupos
  grupo<-c(rep(1,16), rep(2,15), rep(3,13))

  #Chamada do pacote de sobrevivencia
  require(survival)

  # Analise usando o estimador de Kaplan-Meier para cada grupo
  ekm <- survfit(Surv(tempos,cens)~grupo)

  #Informacoes sobre os modelos
  summary(ekm)
  
  #Plotagem das curvas de sobrevivencia  
  plot(ekm
       ,lty=c(1,4,2)
       ,xlab="Tempo"
       ,ylab="S(t) estimada")

  #Legenda
  legend(1,0.3
         ,lty=c(1,4,2)
         ,c("Grupo 1","Grupo 2", "Grupo 3")
         ,lwd=1
         ,bty="n"
         ,cex=0.8)
  
  #Diferencas das curvas de sobrevivencia  
  survdiff(Surv(tempos,cens)~grupo,rho=0)

  # 1 vs. 2  
  survdiff(Surv(tempos[1:31],cens[1:31])~grupo[1:31],rho=0) 
  
  # 2 vs. 3  
  survdiff(Surv(tempos[17:44],cens[17:44])~grupo[17:44],rho=0)
  
  # 1 vs. 3  
  survdiff(Surv(c(tempos[1:16],tempos[32:44]),c(cens[1:16],
                                                cens[32:44]))~c(grupo[1:16],grupo[32:44]),rho=0)

#End Run(Fun)time



  #########################################
  #Cap??tulo 3 - Modelos Probabilisticos
  #########################################

# Esses modelos probabilisticos sao conhecidos tambem como parametricos, em que a 
# caracteristica desses modelos e de usar as distribuicoes da estatistica para 
# determinar tempos de vida.

# Esse tipo de modelos sao mais usados na engenharia do que na medicina, dado que
# na engenharia as fontes de perturbacao podem ser controladas (heterogeneidade), 
# enquanto esse arranjo de pertubacoes e mais raro na medicina.

# Na analise de sobrevivencia, muitos dos modelos de distribuicao de probabilidades 
# sao usados de uma forma nao tao "plain vannila" como na estatistica basica aplicada.

# Esses modelos em sua grande parte, sao baseadas nas distribuicoes e os mais usados na
# analise de sobrevivencia, em se tratando de modelos parametricos para estimativa
# de tempo de falha sao:

# a. Distribuicao Gaussiana
# b. Distribuicao Exponencial: Nao possui memoria, isso e considera o risco (taxa de falha) constante independente do tempo no qual o evento esta.
# c. Distribuicao Weibull: Tem a caracteristica de ter a sua taxa de falha monotona, isso e, crescimento, decrescimento ou estatica de forma constante.
# d. Distribuicao log-Normal: Analise que tem os mesmos efeitos da analise da normal, mas com a caracteristica dos dados nao terem nenhum tipo de extrapolacao que fuja da escala logaritmica.
# e. Distribuicao log-logistica:  
# f. Distribuicao gama/gama generalizada: E usada fitting em eventos de falha que possam acontecer ao mesmo tempo, mas que a proxima falha leve muito tempo para ser vista. E utilizada em modelos de reliability e fragilidade.
  
  
# Quantidade de parametros por modelo
#   Distribuicao Exponencial = 1
#   Distribuicao Weibil, Log-normal, Gama = 2
#   Distribuicao Gama Generalizado = 3

# Quando se trabalha com dados censurados, ?? incorreto se usar o m??todo de minimos quadrados, 
# proveniente das regressoes, dado que esse tipo de inferencia nao absorve as informacoes
# das censuras no modelo de dados.

# Sendo assim os estimadores de verosimmilanca sao os mais adequados para esse tipo de estimacao.

  
  
  
  
  
  
#Start Run(Fun)time  

  # Chamada do pacote  
  require(survival)
  
  # 20 pacentes submetidos ao tratamento com laser
  tempos<-c(3,5,6,7,8,9,10,10,12,15,15,18,19,20,22,25,28,30,40,45)
  
  # Censuras
  cens<-c(1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0)
  
  # Ajuste utilizando a distribuicao exponencial
  ajust1 <- survreg(Surv(tempos,cens)~1,dist='exponential')
  
  # Objeto do ajuste
  ajust1

  #Parametro Alpha
  alpha <- exp(ajust1$coefficients[1])
  
  #Intercepto do parametro Alpha
  alpha

  # Ajuste utilizando a distribuicao weibull
  ajust2 <- survreg(Surv(tempos,cens)~1,dist='weibull')

  #Objeto do ajuste seguindo a distribuicao de Weibull
  ajust2

  #Parametro Alpha
  alpha <- exp(ajust2$coefficients[1])

  #Ajuste do parametro
  gama <- 1/ajust2$scale

  #Juncao dos parametros 
  cbind(gama, alpha)

  #Ajuste usando a distribuicao log-normal
  ajust3 <- survreg(Surv(tempos,cens)~1,dist='lognorm')

  #Objeto da Log-Normal
  ajust3


  #Obtencao das estimativas usando os 4 modelos 
  
  #Estimativa usando o estimador de Kaplan-Meier
  ekm<-survfit(Surv(tempos,cens)~1)

  #Variavel de tempo do estimador de Kaplan-Meier
  time <- ekm$time

  #Survival time no estimador de Kaplan-Meier
  st <- ekm$surv

  #Estimador usando a distribuicao exponencial
  ste<- exp(-time/20.41)
  
  #Estimador usando a distribuicao de Weibull
  stw<- exp(-(time/21.34)^1.54)
  
  #Estimador usando a distribuicao Log-Normal
  stln<- pnorm((-log(time)+ 2.72)/0.76)
  
  #Binding das colunas com os resutados
  cbind(time,st,ste,stw,stln)


  
  # Plotagem dos 3 graficos de sobrevivencias estimadas de Kaplan-Meier contra
  # os modelos exponencial, weibull, e log-normal
  
  par(mfrow=c(1,3))
  
  plot(st
       ,ste
       ,pch=16
       ,ylim=range(c(0.0,1))
       ,xlim=range(c(0,1))
       ,xlab = "S(t): Kaplan-Meier"
       ,ylab="S(t): exponencial")
  lines(c(0,1), c(0,1), type="l", lty=1)
  
  
  plot(st
       ,stw
       ,pch=16
       ,ylim=range(c(0.0,1))
       ,xlim=range(c(0,1))
       ,xlab = "S(t): Kaplan-Meier"
       ,ylab="S(t): Weibull")
  lines(c(0,1), c(0,1), type="l", lty=1)
  
  
  plot(st
       ,stln
       ,pch=16
       ,ylim=range(c(0.0,1))
       ,xlim=range(c(0,1))
       ,xlab = "S(t): Kaplan-Meier"
       ,ylab="S(t): log-normal")
  lines(c(0,1), c(0,1), type="l", lty=1)
  
  
  
  # Plotagem de 3 graficos de modelos linearizados
  par(mfrow=c(1,3))
  
  invst <- qnorm(st)
  plot(time, -log(st),pch=16,xlab="tempos",ylab="-log(S(t))")
  plot(log(time),log(-log(st)),pch=16,xlab="log(tempos)",ylab="log(-log(S(t)))")
  plot(log(time),invst, pch=16,xlab="log(tempos)", ylab=expression(Phi^-1 * (S(t))))
  
  # Valores do logaritmo de verosimilhanca 
  ajust1$loglik[2]
  ajust2$loglik[2]
  ajust3$loglik[2]
  
  # Plotagem de graficos dos modelos Weibull e Log-Normal contra Kaplan-Meier
  par(mfrow=c(1,2))
  
  plot(ekm, conf.int=F, xlab="Tempos", ylab="S(t)")
  lines(c(0,time),c(1,stw), lty=2)
  legend(25,0.8,lty=c(1,2),c("Kaplan-Meier", "Weibull"),bty="n",cex=0.8)
  
  plot(ekm, conf.int=F, xlab="Tempos", ylab="S(t)")
  lines(c(0,time),c(1,stln), lty=2)
  legend(25,0.8,lty=c(1,2),c("Kaplan-Meier", "Log-normal"),bty="n",cex=0.8)

#End Run(Fun)time  


  ##################################################
  #Cap??tulo 4 - Modelos de Regressao Parametricos
  ##################################################
  
# Como as tecnicas nao-parametricas nao permitem a inclusao de covariaveis no modelo
# de sobrevivencia (o que deixaria o modelo mais robusto), as tecnicas baseada em regressores
# sao utilizadas pela forma intuitiva do tratamento dessas formulas, e tambem permitir 
# uma maior robustez no modelo como um todo. 

# Uma das formas de se contonar essa limitacao dos metodos nao-parametricos, e realizar
# a criacao das funcoes de acordo com as covariaveis presentes nos dados, atraves dos estratos.

# Os modelos semi-parametricos, que tem destaque a regresao de Cox, permite incorporar
# covariaveis dependentes do tempo de acordo com a sua frequencia de aparicao.


  
  
  
  

#Start Run(Fun)time  
temp<-c(65,156,100,134,16,108,121,4,39,143,56,26,22,1,1,5,65)
cens<-rep(1,17)
lwbc<-c(3.36,2.88,3.63,3.41,3.78,4.02,4.00,4.23,3.73,3.85,3.97,
        4.51,4.54,5.00,5.00,4.72,5.00)
dados<-cbind(temp,cens,lwbc)
require(survival)
dados<-as.data.frame(dados)
i<-order(dados$temp)
dados<-dados[i,]
ekm<- survfit(Surv(dados$temp,dados$cens)~1)
summary(ekm)
st<-ekm$surv
temp<-ekm$time
invst<-qnorm(st)
par(mfrow=c(1,3))
plot(temp, -log(st),pch=16,xlab="Tempos",ylab="-log(S(t))")
plot(log(temp),log(-log(st)),pch=16,xlab="log(tempos)",ylab="log(-log(S(t))")
plot(log(temp),invst,pch=16,xlab="log(tempos)",ylab=expression(Phi^-1*(S(t))))
#End Run(Fun)time  



#Start Run(Fun)time  
ajust1<-survreg(Surv(dados$temp, dados$cens)~dados$lwbc, dist='exponential')
ajust1
ajust1$loglik
ajust2<-survreg(Surv(dados$temp, dados$cens)~dados$lwbc, dist='weibull')
ajust2
ajust2$loglik
gama<-1/ajust2$scale
gama
#End Run(Fun)time  


#Start Run(Fun)time  
desmame<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/desmame.txt",h=T)  # desmame.txt no Ap??ndice A3
attach(desmame)
require(survival)
ekm<- survfit(Surv(tempo,cens)~V4)
summary(ekm)
survdiff(Surv(tempo,cens)~V4,rho=0)
plot(ekm,lty=c(1,4),mark.time=F,xlab="Tempo at?? o desmame (meses)",ylab="S(t)")
text(18.5,0.93,c("Dificuldades para Amamentar"),bty="n", cex=0.85)
legend(15.5,0.9,lty=c(4),c("Sim"),bty="n",cex=0.8)
legend(18.5,0.9,lty=c(1),c("N??o"),bty="n",cex=0.8)
#End Run(Fun)time  


#Start Run(Fun)time  
ajust1<-survreg(Surv(tempo,cens)~V1+V3+V4+V6, dist='lognorm')
ajust1
summary(ajust1)
#End Run(Fun)time  


#Start Run(Fun)time  
xb<-ajust1$coefficients[1]+ajust1$coefficients[2]*V1+ajust1$coefficients[3]*V3+
  ajust1$coefficients[4]*V4+ ajust1$coefficients[5]*V6
sigma<-ajust1$scale
res<-(log(tempo)-(xb))/sigma                   # res??duos padronizados
resid<-exp(res)                                # exponencial dos res??duos padronizados
ekm<- survfit(Surv(resid,cens)~1)
resid<-ekm$time
sln<-pnorm(-log(resid))
par(mfrow=c(1,2))
plot(ekm$surv,sln, xlab="S(ei*): Kaplan-Meier",ylab="S(ei*): Log-normal padr??o",pch=16)
plot(ekm,conf.int=F,mark.time=F,xlab="Res??duos (ei*)",ylab="Sobreviv??ncia estimada",pch=16)
lines(resid,sln,lty=2)
legend(1.3,0.8,lty=c(1,2),c("Kaplan-Meier","Log-normal padr??o"),cex=0.8,bty="n")
#End Run(Fun)time  


#Start Run(Fun)time  
ei<- -log(1-pnorm(res))                          # res??duos de Cox-Snell
ekm1<-survfit(Surv(ei,cens)~1)
t<-ekm1$time
st<-ekm1$surv
sexp<-exp(-t)
par(mfrow=c(1,2))
plot(st,sexp,xlab="S(ei): Kaplan-Meier",ylab="S(ei): Exponencial padr??o",pch=16)
plot(ekm1,conf.int=F,mark.time=F, xlab="Res??duos de Cox-Snell", ylab="Sobreviv??ncia estimada")
lines(t,sexp,lty=4)
legend(1.0,0.8,lty=c(1,4),c("Kaplan-Meier","Exponencial padr??o"),cex=0.8,bty="n")
#End Run(Fun)time  



    ##################################################
    #Cap??tulo 5 - Modelo de Regressao de Cox
    ##################################################


laringe<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/laringe.txt", h=T)     #Obs: laringe.txt no Ap??ndice A6
attach(laringe)
require(survival)
fit2<-coxph(Surv(tempos,cens)~factor(estagio), data=laringe,
            x = T, method="breslow")
summary(fit2)
fit2$loglik
fit3<- coxph(Surv(tempos,cens)~factor(estagio)+ idade, data=laringe,
             x = T, method="breslow")
summary(fit3)
fit3$loglik
fit4<-coxph(Surv(tempos,cens) ~ factor(estagio) + idade + factor(estagio)*idade,
            data=laringe, x = T, method="breslow")
summary(fit4)
fit4$loglik


resid(fit4,type="scaledsch")
cox.zph(fit4, transform="identity")        ### g(t) = t
par(mfrow=c(2,4))
plot(cox.zph(fit4))


resid(fit3,type="scaledsch")
cox.zph(fit3, transform="identity")    # g(t) = t
par(mfrow=c(1,4))
plot(cox.zph(fit3))

Ht<-basehaz(fit4,centered=F)
tempos<-Ht$time
H0<-Ht$hazard
S0<- exp(-H0)
round(cbind(tempos, S0,H0),digits=5)



require(survival)
desmame<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/desmame.txt",h=T)    #Obs: desmame.txt no Ap??ndice A3
attach(desmame)
fit<-coxph(Surv(tempo,cens)~V1+V3+V4+V6,data=desmame,x = T,method="breslow")
summary(fit)
fit$loglik

resid(fit,type="scaledsch")
cox.zph(fit, transform="identity")     ## g(t) = t
par(mfrow=c(2,2))
plot(cox.zph(fit))


rm(list=ls())
leuc<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/leucemia.txt", h=T)        #Obs: leucemia.txt no Ap??ndice A1
attach(leuc)
idadec<-ifelse(idade>96,1,0)
leuinic<-ifelse(leuini>75,1,0)
zpesoc<-ifelse(zpeso>-2,1,0)
zestc<-ifelse(zest>-2,1,0)
vacc<-ifelse(vac>15,1,0)
pasc<-ifelse(pas>5,1,0)
riskc<-ifelse(risk>1.7,1,0)
r6c<-r6
leucc<-as.data.frame(cbind(leuinic,tempos,cens,idadec,zpesoc,zestc,pasc,vacc,riskc,r6c))
detach(leuc)
attach(leucc)
require(survival)
fit<-coxph(Surv(tempos,cens)~leuinic+idadec+zpesoc+zestc+pasc+vacc+riskc+r6c,
           data=leucc, x = T, method="breslow")
summary(fit)


fit3<-coxph(Surv(tempos,cens)~leuinic+idadec+zpesoc+pasc+vacc,data=leucc,x = T,method="breslow")
summary(fit3)
-2*fit3$loglik[2]

resid(fit3,type="scaledsch")
cox.zph(fit3, transform="identity")   ## g(t) = t
par(mfrow=c(2,3))
plot(cox.zph(fit3))

par(mfrow=c(1,2))
rd<-resid(fit3,type="deviance")       # res??duos deviance
rm<-resid(fit3,type="martingale")     # res??duos martingal
pl<-fit3$linear.predictors
plot(pl,rm, xlab="Preditor linear", ylab="Res??duo martingal", pch=16)
plot(pl,rd,  xlab="Preditor linear", ylab="Res??duo deviance" , pch=16)


par(mfrow=c(2,3))
dfbetas<-resid(fit3,type="dfbeta")
plot(leuinic,dfbetas[,1], xlab="Leuini", ylab="Influ??ncia para Leuini")
plot(idadec, dfbetas[,2], xlab="Idade",  ylab="Influ??ncia para Idade")
plot(zpesoc, dfbetas[,3], xlab="Zpeso",  ylab="Influ??ncia para Zpeso")
plot(pasc,   dfbetas[,4], xlab="Pas",    ylab="Influ??ncia para Pas")
plot(vacc,   dfbetas[,5], xlab="Vac",    ylab="Influ??ncia para Vac")

C??digos em R apresentados no Cap??tulo 6
##############################################

aids<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/aids.txt",h=T)  ## Obs: arquivo aids.txt no Ap??ndice A2
attach(aids)
require(survival)
fit1<-coxph(Surv(ti[ti<tf], tf[ti<tf], cens[ti<tf])~id[ti<tf]+factor(grp)[ti<tf],method="breslow")
summary(fit1)


leuc<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/leucemia.txt", h=T)  #Obs: leucemia.txt no Ap??ndice A1
attach(leuc)
idadec<-ifelse(idade>96,1,0)
leuinic<-ifelse(leuini>75,1,0)
zpesoc<-ifelse(zpeso>-2,1,0)
zestc<-ifelse(zest>-2,1,0)
vacc<-ifelse(vac>15,1,0)
pasc<-ifelse(pas>5,1,0)
riskc<-ifelse(risk>1.7,1,0)
r6c<-r6
leucc<-as.data.frame(cbind(leuinic,tempos,cens,idadec,zpesoc,zestc,pasc,vacc,riskc,r6c))
detach(leuc)
attach(leucc)
require(survival)
fit1<-coxph(Surv(tempos,cens)~idadec+zpesoc+pasc+vacc+strata(leuinic),data=leucc,
            x = T,method="breslow")
summary(fit1)


leucc1<-as.data.frame(cbind(tempos[leuinic==0],cens[leuinic==0],idadec[leuinic==0],
                            zpesoc[leuinic==0],pasc[leuinic==0],vacc[leuinic==0]))
leucc2<-as.data.frame(cbind(tempos[leuinic==1],cens[leuinic==1],idadec[leuinic==1],
                            zpesoc[leuinic==1],pasc[leuinic==1],vacc[leuinic==1]))
fit2<-coxph(Surv(V1,V2)~V3+V4+V5+V6,data=leucc1,x = T,method="breslow")
summary(fit2)
fit3<-coxph(Surv(V1,V2)~V3+V4+V5+V6,data=leucc2,x = T,method="breslow")
summary(fit3)
trv<-2*(-fit1$loglik[2]+fit2$loglik[2]+fit3$loglik[2])
trv
1-pchisq(trv,4)

cox.zph(fit1, transform="identity")   # g(t) = t
par(mfrow=c(1,4))
plot(cox.zph(fit1))

H0<-basehaz(fit1,centered=F)                    # risco acumulado de base
H0
H01<-as.matrix(H0[1:27,1])                      # risco acumulado de base do estrato 1 (leuinic=0)
H02<-as.matrix(H0[28:39,1])                     # risco acumulado de base do estrato 2 (leuinic=1)
tempo1<- H0$time[1:27]                          # tempos do estrato 1
S01<-exp(-H01)                                  # sobreviv??ncia de base estrato 1
round(cbind(tempo1,S01,H01),digits=5)           # fun????es de base estrato 1
tempo2<- H0$time[28:39]                         # tempos do estrato 2
S02<-exp(-H02)                                  # sobreviv??ncia de base estrato 2
round(cbind(tempo2,S02,H02),digits=5)           # fun????es de base estrato 2

par(mfrow=c(1,2))
plot(tempo2,H02,lty=4,type="s",xlab="Tempos",xlim=range(c(0,4)),ylab=expression(Lambda[0]* (t)))
lines(tempo1,H01,type="s",lty=1)
legend(0.0,9,lty=c(1,4),c("Leuini < 75000","Leuini > 75000"),lwd=1,bty="n",cex=0.8)
plot(c(0,tempo1),c(1,S01),lty=1,type="s",xlab="Tempos",xlim=range(c(0,4)),ylab="So(t)")
lines(c(0,tempo2),c(1,S02),lty=4,type="s")
legend(2.2,0.9,lty=c(1,4),c("Leuini < 75000","Leuini > 75000"),lwd=1,bty="n",cex=0.8)


hg2<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/hg2.txt",h=T)    # arquivo hg2.txt no Ap??ndice A7
attach(hg2)
require(survival)
fit1<-coxph(Surv(tempos,cens)~factor(raca)+factor(trauma)+factor(recemnas)+
              factor(renda)+ialtura+factor(trauma)*factor(recemnas),data=hg2,method="breslow")
summary(fit1)
rendac<-ifelse(renda<4,1,2)
fit2<-coxph(Surv(tempos,cens)~factor(raca)+factor(trauma)+factor(recemnas)+factor(rendac)+
              ialtura + factor(trauma)*factor(recemnas),data=hg2,method="breslow")
summary(fit2)
cox.zph(fit2, transform="identity")
par(mfrow=c(2,3))
plot(cox.zph(fit2))


C??digos em R apresentados no Cap??tulo 7
##############################################

laringe<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/laringe.txt", h=T) #Obs: laringe.txt no Ap??ndice A6
attach(laringe)
require(survival)
source("http://www.ufpr.br/~giolo/Livro/ApendiceA/Addreg.r")  ## obter fun????o em http://www.med.uio.no/imb/stat/addreg/
idadec<-idade-mean(idade)
fit1<- addreg(Surv(tempos,cens)~factor(estagio)+idadec,laringe)
summary(fit1)
fit2<- addreg(Surv(tempos,cens)~factor(estagio),laringe)
summary(fit2)

i<-order(tempos)
laringe<-laringe[i,]     # dados ordenados pelos tempos
laringe1<-laringe[1:51,] # Obs: como tau = 4.3 devemos usar somente as linhas em que t <= 4.3
xo<-rep(1,51)
x1<-ifelse(laringe1$estagio==2,1,0)
x2<-ifelse(laringe1$estagio==3,1,0)
x3<-ifelse(laringe1$estagio==4,1,0)
x <-as.matrix(cbind(xo,x1,x2,x3))
t<-fit2$times
coef<-fit2$increments
xt<-t(x)
Bt<-coef%*%xt
riscoacum<-diag(Bt)
for(i in 1:50){
  riscoacum[i+1]<-riscoacum[i+1]+riscoacum[i]}
riscoacum
plot(t,riscoacum,xlab="Tempos", ylab = expression(Lambda*(t)), pch=16)


plot(fit2,xlab="Tempo",ylab="FRA",labelofvariable=c("Estadio I","Estadio II em rela????o ao I",
                                                    "Estadio III em rela????o ao I","Estadio IV em rela????o ao I"))



source("http://www.ufpr.br/~giolo/Livro/ApendiceA/Addreg.r")    # lendo no R a fun????o Addreg.r
aids<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/aids.txt",h=T) # lendo aids.txt (Ap??ndice A2)
attach(aids)
require(survival)
idade<-id - mean(id[!is.na(id)])
fit1<-addreg( Surv(ti[ti<tf],tf[ti<tf],cens[ti<tf])~idade[ti<tf]+sex[ti<tf]+factor(grp)[ti<tf],
              data=aids)
summary(fit1)
fit2<-addreg( Surv(ti[ti<tf],tf[ti<tf],cens[ti<tf])~idade[ti<tf]+factor(grp)[ti<tf], data=aids)
summary(fit2)

aids<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA",h=T)                # lendo aids.txt (Ap??ndice A2)
attach(aids)
aids1<-as.data.frame(cbind(tf,id,grp))
aids1<-na.omit(aids1)    # eliminando valores missing = NA
attach(aids1)
i<-order(aids1$tf)
aids1<-aids1[i,]         # banco de dados ordenados por tf e sem NA nas covariaveis
aids2<-aids1[10:121,]    # tau = 617 e ent??o foram mantidas as linhas em que 0 < tf <= 617
n<-nrow(aids2)
xo<-rep(1,n)
x1<-(aids2$id) - mean(aids2$id)
x2<-ifelse(aids2$grp==2,1,0)
x3<-ifelse(aids2$grp==3,1,0)
x4<-ifelse(aids2$grp==4,1,0)
x <-as.matrix(cbind(xo,x1,x2,x3,x4))
t<-fit2$times
coef<-fit2$increments
xt<-t(x)
Bt<-coef%*%xt
riscoacum<-diag(Bt)
for(i in 1:(n-1)){
  riscoacum[i+1]<-riscoacum[i+1]+riscoacum[i]}
riscoacum
plot(t,riscoacum,xlab="Tempos", ylab = expression(Lambda*(t)), pch=16)


plot(fit2,xlab="Tempo",ylab="FRA",label=c("(a) Constante","(b) Idade", "(c) Assintom??tico em rela????o HIV-",
                                          "(d) ARC em  rela????o HIV-", "(e) AIDS em rela????o HIV-"))


C??digos em R apresentados no Cap??tulo 8
##############################################

require(survival)
source("http://www.ufpr.br/~giolo/Livro/ApendiceE/Turnbull.R")        # lendo no R a fun????o Turnbull.R (Ap??ndice E)
left<-c(0,1,4,5,5)
right<-c(5,8,9,8,9)
dat<-as.data.frame(cbind(left,right))
attach(dat)
right[is.na(right)] <- Inf
tau <- cria.tau(dat)
p <- S.ini(tau=tau)
A <- cria.A(data=dat,tau=tau)
tb <- Turnbull(p,A,dat)
tb

rm(list=ls())
require(survival)
source("http://www.ufpr.br/~giolo/Livro/ApendiceE/Turnbull.R")                     # Turnbull.R no Ap??ndice E
dat <- read.table('http://www.ufpr.br/~giolo/Livro/ApendiceA/breast.txt',header=T)    # breast.txt no Ap??ndice A9
dat1 <- dat[dat$ther==1,]
dat1$right[is.na(dat1$right)] <- Inf
tau <- cria.tau(dat1)
p <- S.ini(tau=tau)
A <- cria.A(data=dat1,tau=tau)
tb1 <- Turnbull(p,A,dat1)
tb1
dat1 <- dat[dat$ther==0,]
dat1$right[is.na(dat1$right)] <- Inf
tau <- cria.tau(dat1)
p <- S.ini(tau=tau)
A <- cria.A(data=dat1,tau=tau)
tb2 <- Turnbull(p,A,dat1)
tb2
plot(tb1$time,tb1$surv, lty=1, type = "s", ylim=c(0,1), xlim=c(0,50),
     xlab="Tempos (meses)",ylab="S(t)")
lines(tb2$time,tb2$surv,lty=4,type="s")
legend(1,0.3,lty=c(1,4),c("Radioterapia","Radioterapia + Quimioterapia"),
       bty="n",cex=0.8)

p <-dat$left+((dat$right-dat$left)/2)
pm <-ifelse(is.finite(p),p,dat$left)
cens <- ifelse(is.finite(p),1,0)
ekm<-survfit(Surv(pm,cens)~ther,type=c("kaplan-meier"),data=dat)
plot(tb1$time,tb1$surv,lty=1,type="s",ylim=c(0,1), xlim=c(0,50),
     xlab="Tempos (meses)",ylab="S(t)")
lines(tb2$time,tb2$surv,lty=2,type="s")
lines(ekm[1]$time,ekm[1]$surv,type="s",lty=3)
lines(ekm[2]$time,ekm[2]$surv,type="s",lty=3)
legend(1,0.3,lty=c(1,2), c("Radioterapia","Radioterapia + Quimioterapia"),
       bty="n",cex=0.8)
legend(1,0.21,lty=3, "Usando Ponto M??dio dos Intervalos", bty="n",cex=0.8)


breast<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/breast.txt", h=T)   #Obs: breast.txt no Ap??ndice A9
attach(breast)
cens1<-ifelse(cens==1,3,0)
require(survival)
fit1<-survreg(Surv(left,right,type="interval2")~ther,breast,dist="logistic")
summary(fit1)
fit2<-survreg(Surv(left,right,type="interval2")~ther,breast,dist="gaussian")
summary(fit2)

t1<-0:50
b0<-fit1$coefficients[1]
b1<-fit1$coefficients[2]
s<- fit1$scale
a1<- t1-(b0+b1)
e1<- exp(a1/s)
st1<-1/(1+e1)
t2<-0:50
a2<- t2-(b0)
e2<- exp(a2/s)
st2<-1/(1+e2)
plot(t1,st1,type="l",lty=3,ylim=range(c(0,1)),xlab="Tempos",ylab="Sobrevivencia estimada")
lines(t2,st2,type="l",lty=3)
t1<-0:45
b0<-fit2$coefficients[1]
b1<-fit2$coefficients[2]
s<- fit2$scale
a1<- t1-(b0+b1)
st11<- 1-pnorm(a1/s)
t2<-0:60
a2<-t2-(b0)
st22<- 1 -pnorm(a2/s)
lines(t2,st22,type="l",lty=2)
lines(t1,st11,type="l",lty=2)
legend(1,0.2,lty=c(3,2),c("Log??stica","Gaussiana"),lwd=1,bty="n",cex=0.8) 


breast<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/breast.txt", h=T)     # breast.txt no ap??ndice A.9
attach(breast)
require(survival)
require(intcox)            # fun????o intcox dispon??vel em www.r-project.org
fit1 <- intcox(Surv(left, right, type = "interval2") ~ ther, data = breast)
summary(fit1)

id<-1:nrow(breast)
set.seed(123)
pat <- unique(id)
intcox.boot.AA <- function(i, form) {
  boot.sample <- sample(pat, length(pat), replace = T)
  data.ind <- unlist(lapply(boot.sample, function(x, yy)
    which(yy ==x), yy = id))
  data.sample <- breast[data.ind, ]
  boot.fit <- intcox(form, data = data.sample, no.warnings = TRUE)
  return(list(coef = coef(boot.fit), term = boot.fit$termination))
}
n.rep <- 1000                   # Obs: usar no minimo 999
AA.boot <- lapply(1:n.rep, intcox.boot.AA, form = Surv(left,
                                                       right, type = "interval2") ~ ther)
AA.boot <- matrix(unlist(AA.boot), byrow = T, nrow = n.rep)
colnames(AA.boot) <- c(names(coef(fit1)), "termination")
inf.level <- 0.05
ther.ord <- order(AA.boot[, "ther"])
pos.lower <- ceiling((n.rep + 1) * (inf.level/2))
pos.upper <- ceiling((n.rep + 1) * (1 - inf.level/2))
ci.ther <- AA.boot[ther.ord, "ther"][c(pos.lower, pos.upper)]
ci.ther



mang<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/mang.txt",h=T)     #Obs: mang.txt no Ap??ndice A5
attach(mang)
require(survival)
ekm<-survfit(Surv(ti,cens)~1,conf.type="none")
summary(ekm)

mang1<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/dadmang.txt",h=T)  #Obs: ver como obter dadmang.txt no Ap??ndice A5
attach(mang1)
require(survival)
fit1<-glm(y~-1+int1+int2+int3+int4+int5+int6+int7+int8+int9+int10+int11+int12+
            factor(bloco,levels=5:1)+ factor(copa)+ factor(cavalo)+
            factor(copa)*factor(cavalo),family=binomial(link="cloglog"))
anova(fit1)
fit2 <-glm(y~-1+int1+int2+int3+int4+int5+int6+int7+int8+int9+int10+int11+int12+
             factor(bloco,levels=5:1)+ factor(copa)+ factor(cavalo)+
             factor(copa)*factor(cavalo),family=binomial(link="logit"))
anova(fit2)


fit1<-glm(y~-1+int1+int2+int3+int4+int5+int6+int7+int8+int9+int10+
            int11+int12+factor(bloco,levels=5:1)+factor(copa),
          family=binomial(link="cloglog"))
summary(fit1)
fit2<-glm(y~-1+int1+int2+int3+int4+int5+int6+int7+int8+int9+int10+
            int11+int12+factor(bloco,levels=5:1)+factor(copa),
          family=binomial(link="logit"))
summary(fit2)


C??digos em R apresentados no Cap??tulo 9
##############################################



agfit<- coxph(Surv(start,stop,status)~ x1 + x2 + cluster(id), data = data1)
wfit<- coxph(Surv(time,status)~ x1+x2+cluster(id)+strata(stratum),data=data2)
cfit<-coxph(Surv(start,stop,status)~x1+x2+cluster(id)+strata(stratum),data=data1)


leucc<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/leucc.txt",h=T)  #Obs: leucc.txt = dados leucemia dicotomizados
attach(leucc)
require(survival)
id<-1:103
fit3a<-coxph(Surv(tempos,cens)~leuinic+idadec+zpesoc+pasc+vacc+frailty(id,dist="gamma"),
             data=leucc,x = T,method="breslow")
summary(fit3a)
wi<-fit3a$frail
zi<-exp(wi)
plot(id,zi, xlab="Crian??as (1 a 103)", ylab="zi estimados", pch=16)
abline(h=1,lty=2)


cattle<-read.table("http://www.ufpr.br/~giolo/Livro/ApendiceA/cattle.txt",h=T)  # cattle.txt no Ap??ndice A8
attach(cattle)
require(survival)
fit1<-coxph(Surv(tempo,censura)~factor(sex)+ agedam + frailty(sire,dist="gamma"),data=cattle)
summary(fit1)
fit2<-coxph(Surv(tempo,censura)~factor(sex)+  frailty(sire,dist="gamma"),data=cattle)
summary(fit2)


H0<-basehaz(fit2,centered=F)
S0<-exp(-H0$hazard)
S3m<-S0^(1.798*exp(0.797))    # machos touro 3
S3f<-S0^(1.798)               # f??meas touro 3
S1m<-S0^(0.767*exp(0.797))    # machos touro 1
S1f<-S0^(0.767)               # f??meas touro 1
par(mfrow=c(1,2))
t<-H0$time
plot(t,S1m, type="s", ylim=range(c(0,1)),xlab="Tempo (dias)",ylab="Sobreviv??ncia Estimada")
lines(t,S1f,type="s",lty=4)
legend(142,0.25, lty=c(1,4),c("Machos", "F??meas"), bty="n", cex=0.8)
title("Touro 1")
plot(t,S3m, type="s",ylim=range(c(0,1)),xlab="Tempo (dias)",ylab="Sobreviv??ncia Estimada")
lines(t,S3f,type="s",lty=4)
legend(142,0.25, lty=c(1,4),c("Machos", "F??meas"), bty="n", cex=0.8)
title("Touro 3")
