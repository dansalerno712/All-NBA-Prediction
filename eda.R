library(caret)
library(randomForest)
library(tidyr)
library(purrr)
library(randomForest)


rm(list = ls())

# Read in data ----
data <- read.csv("finalData.csv")

# Clean data ----
data[, "allnba"] <- factor(data[, "allnba"])
data[, "allstar"] <- factor(data[, "allstar"])
# get rid of useless columns - GS included here because there are NAs in it for some reason
# The combination of G and MP should cover this fine
data <- subset(data, select = -c(X, Tm, Lg, GS))

# Summarize Data ----
summary(data)

# Plot vs allnba ----
# get rid of any non numeric columns
plots <- keep(data, is.numeric)
# but go back and add allnba since we need that to color out plots
plots$allnba <- data$allnba

# use pairs to generate the data structure needed for ggplot
# make sure you don't include allnba in the mapping so we can use it for color
pairs = gather(plots , -allnba, key = "var", value = "value")

# plot the density plot with allnba coloration for all variables
ggplot(pairs, aes(x = value, fill = allnba)) + geom_density(alpha = 0.3) + facet_wrap(~var, scales = "free")

# Important features ----
model <- randomForest(allnba ~ . - Season - Player, data = data, importance = TRUE, ntree = 1000, na.action = na.omit)
varImpPlot(model)

