# Clear the console
cat("\014")  

# Load arules library
library(arules)

# Load Dataset - This is a synthetic dataset, some inconsistencies can be found... as in the real world! ;)
crimes <- read.csv("https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/01%20-%20Association%20Rules/Crimes.csv")

# See variables types
str(crimes)

# See basic stats
summary(crimes)

# The most important thing it's get a good suport and a great confidence (This is a wishful thinking, in real world EVERYTHING can be happen!)
# The main task here is get a set a most meaningful way, so, shity rules will be discarted.
crimes_rulez <- apriori(crimes, parameter = list(minlen=4,maxlen=10, supp=0.55, conf=0.80))

# Reduce the number of digits in measures of quality of the model
quality(crimes_rulez) <- round(quality(crimes_rulez), digits=2)

# Sort by Confidence and Support and Lift
model_srt_confidence <- sort(crimes_rulez, by="confidence")

model_srt_support <- sort(crimes_rulez, by="support")

model_srt_lift <- sort(crimes_rulez, by="lift")

# Check models (#66 rules)
inspect(model_srt_confidence)

inspect(model_srt_support)

inspect(model_srt_lift)

#See top 10 Rules for each set of models
inspect(crimes_rulez[1:10])

inspect(model_srt_confidence[1:10])

inspect(model_srt_support[1:10])

inspect(model_srt_lift[1:10])

# See specific rules of zones (I already mined some rules, but feel free to discover)
Zona_Sul <- subset(crimes_rulez, subset = rhs %pin% "Zona=Zona_Sul")

Iluminacao_Sim <- subset(crimes_rulez, subset = rhs %pin% "Iluminacao=Sim")

Ocorrencia_Atendida_15_Minutos_Sim <- subset(crimes_rulez, subset = rhs %pin% "Ocorrencia_Atendida_15_Minutos=Sim")

Policiamento_Ostensivo <- subset(crimes_rulez, subset = rhs %pin% "Policiamento_Ostensivo=Sim")

# Specific Rules
inspect(Zona_Sul)

inspect(Iluminacao_Sim)

inspect(Ocorrencia_Atendida_15_Minutos_Sim)

inspect(Policiamento_Ostensivo)


# More Rules to export (40% support)
crimes_rulez_2 <- apriori(crimes, parameter = list(minlen=4,maxlen=20, supp=0.4, conf=0.90))

# Object to output
out <- capture.output(inspect(crimes_rulez_2))

# Output file
cat("Regras", out, file="regras.txt", sep="n", append=TRUE)
