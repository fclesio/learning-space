#Load Dataset
voting <- read.csv("https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/01%20-%20Association%20Rules/USA_voting_1984.csv")

#See variables
str(voting)

#See basic statistics
summary(voting)

# Construct the model, using a medium support and a mid-high confidence. 
# The parameters of lengh was keeped 'cause we want no obvious rules and more actionable.
model <- apriori(voting
                 ,parameter = list(minlen=3,maxlen=10, supp=0.45, conf=0.70))

# Reduce the number of digits in measures of quality of the model
quality(model) <- round(quality(model), digits=2)

# Sort by some measures
model_srt_confidence <- sort(model, by="confidence")

model_srt_support <- sort(model, by="support")


#Check models 
inspect(model_srt_confidence)

inspect(model_srt_support)

# See specific rules of democrats
democrats <- subset(model, subset = rhs %pin% "Class=democrat")

democrats <- subset(model, subset = rhs %pin% "PericiaInvestigacao=nao")

# See Rules
inspect(democrats)

# Top 20 rules of democrats
inspect(democrats[1:20])
