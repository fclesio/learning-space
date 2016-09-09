
# Load arules library
library(arules)

# Load Dataset
crimes <- read.csv("https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/01%20-%20Association%20Rules/Crimes.csv")

# See variables types
str(crimes)

# See basic stats
summary(crimes)

# The most important thing it's get a good suport and a great confidence
crimes_rulez <- apriori(crimes, parameter = list(minlen=4,maxlen=10, supp=0.55, conf=0.80))

# Reduce the number of digits in measures of quality of the model
quality(crimes_rulez) <- round(quality(crimes_rulez), digits=2)

# Sort by some measures
model_srt_confidence <- sort(crimes_rulez, by="confidence")

model_srt_support <- sort(crimes_rulez, by="support")


# Check models 
inspect(model_srt_confidence)

inspect(model_srt_support)

# See specific rules of zones
Zona_Sul <- subset(crimes_rulez, subset = rhs %pin% "Zona=Zona_Sul")

Zona_Norte <- subset(crimes_rulez, subset = rhs %pin% "Zona=Zona_Norte")

Zona_Leste <- subset(crimes_rulez, subset = rhs %pin% "Zona=Zona_Leste")

Zona_Oeste <- subset(crimes_rulez, subset = rhs %pin% "Zona=Zona_Oeste")

Centro <- subset(crimes_rulez, subset = rhs %pin% "Zona=Centro")



Iluminacao_Sim <- subset(crimes_rulez, subset = rhs %pin% "Iluminacao=Sim")


Ocorrencia_Atendida_15_Minutos_Sim <- subset(crimes_rulez, subset = rhs %pin% "Ocorrencia_Atendida_15_Minutos=Sim")

# See Rules
inspect(Zona_Sul)

# Top 20 rules of Zona_Sul
inspect(Zona_Sul[1:20])
