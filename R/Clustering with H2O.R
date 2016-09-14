########################
# H2O's K-Means function
########################

#Clean Screen in Console
cat("\014") 

#Load Library
library(h2o)

#See cluster configurated
h2o.init()

#Get data from system file called prostate.csv
prostate.hex = h2o.uploadFile(path = system.file("extdata", "prostate.csv", package="h2o"), destination_frame = "prostate")

#See some information about data
summary(prostate.hex)

#Using prostate.hex frame get 10 clusters using some fields
prostate.km = h2o.kmeans(prostate.hex, k = 10, x = c("AGE","RACE","GLEASON","CAPSULE","DCAPS"))

# Show model details
print(prostate.km)

#Transform hex file in dataframe
prostate.data = as.data.frame(prostate.hex)

# Split frames to plot k-means centers
par(mfrow = c(1,2))

#Cluster centroids
prostate.ctrs = as.data.frame(prostate.km@model$centers)


#Plot
plot(prostate.ctrs[,1:2])

plot(prostate.ctrs[,3:4])

title("K-Means Centers for k = 10", outer = TRUE, line = -2.0)
