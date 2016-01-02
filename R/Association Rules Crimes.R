#Install packages
install.packages("arules")
install.packages("arulesViz")
install.packages("grid")

#Load library 
library(arules)
library(arulesViz)
library(grid)

# Load Crimes Dataset
crimes <- read.csv("https://raw.githubusercontent.com/fclesio/learning-space/master/Datasets/01%20-%20Association%20Rules/CrimesOficial.csv")   

# Check Data
str(crimes)

# Summary to see data (See crep data)
summary(crimes)

# Create rules without any preprocessing, but I'll change the default values
model <- apriori(crimes
                ,parameter = list(minlen=2,maxlen=4, supp=0.025, conf=0.70))


# Let's see our model 
inspect(model)

# See the bevavour of our model
summary(model)

#Let's normalize our output
quality(model) <- round(quality(model), digits=2)

# Let's see the quality of of predictions

# Proportions of transactions in a dataset
model_sorted_support <- sort(rules, by="support")

# Probability of such transactions occur in a dataset in such support
model_sorted_confidence <- sort(rules, by="confidence")

# Target response divided by average response (or the absense of the model)
model_sorted_lift <- sort(rules, by="lift")


# See models
inspect(model_sorted_confidence[1:10])

inspect(model_sorted_lift[1:10])

inspect(model_sorted_support[1:10])



# Plot models
plot(model_sorted_confidence)


plot(model_sorted_confidence[1:10], method="graph")


plot(model_sorted_confidence[1:10], method="grouped")




