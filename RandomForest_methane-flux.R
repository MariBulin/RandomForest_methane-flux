
# Load necessary libraries
library(randomForest)
library(tidyverse)
library(GGally) # For correlation plots
library(pdp)    # For partial dependence plots
library(cowplot) # For combining plots
# Citation for randomForest package
citation('randomForest')
# Define the dataset directory
dataset_dir <- "dummy_dataset.csv" # Replace with the actual path to your dataset
# Load the dataset
df <- read.csv(dataset_dir) # Load the dataset from the specified directory
# Define the response variable
y_var <- "Flux_CH4_diff"
# Create a subset dataframe with predictors and response variable
df_rf <- df[, c(y_var, 'max_depth', 'temp', "precip", 'Latitude')]
# Remove rows with missing values
df_rf <- df_rf[complete.cases(df_rf), ]
# Check the number of rows with and without missing values
cat("Number of rows with missing values:", sum(!complete.cases(df_rf)), "\n")
cat("Number of rows without missing values:", sum(complete.cases(df_rf)), "\n")
# Pairwise scatterplots with correlation coefficients
set.seed(71)
pairs(
  df_rf, 
  columns = c('max_depth', 'temp', "precip", 'Latitude'),
  upper = list(continuous = "cor"), # Correlation coefficients
  lower = list(continuous = "smooth"), # Smoothed scatterplots
  diag = list(continuous = "barDiag") # Histograms on the diagonal
)
# Tune the Random Forest model to find the optimal number of predictors (mtry)
rf_tuned <- tuneRF(
  x = df_rf[, !names(df_rf) %in% y_var], # Predictor variables
  y = df_rf[, names(df_rf) %in% y_var],  # Response variable
  ntreeTry = 500,                        # Number of trees to build
  stepFactor = 1.5,                      # Factor to increase mtry
  improve = 0.01,                        # Minimum improvement in OOB error
  trace = TRUE,                          # Show progress
  plot = TRUE                            # Plot OOB error
)
# Select the best mtry value with minimum OOB error
best.m <- rf_tuned[rf_tuned[, 2] == min(rf_tuned[, 2]), 1]
cat("Optimal mtry value:", best.m, "\n")
# Train the Random Forest model
rf <- randomForest(
  Flux_CH4_diff ~ ., 
  data = df_rf, 
  mtry = best.m, 
  importance = TRUE, 
  ntree = 500
)
# Print the Random Forest model summary
print(rf)
# Find the number of trees that produce the lowest test MSE
optimal_trees <- which.min(rf$mse)
cat("Number of trees with lowest MSE:", optimal_trees, "\n")
# Calculate the RMSE of the best model
rmse <- sqrt(rf$mse[optimal_trees])
cat("Root Mean Squared Error (RMSE):", rmse, "\n")
# Plot the test MSE by number of trees
plot(rf, main = "Test MSE by Number of Trees")
# Variable importance analysis
importance(rf) # Print variable importance metrics
varImpPlot(rf, main = "Variable Importance Plot") # Plot variable importance
# Save variable importance as a dataframe
imp <- as.data.frame(importance(rf))
imp <- cbind(vars = rownames(imp), imp)
colnames(imp)[2:3] <- c("MeanDecreaseAccuracy", "MeanDecreaseGini") # Rename columns
imp <- imp[order(imp$MeanDecreaseAccuracy), ] # Sort by importance
imp$vars <- factor(imp$vars, levels = unique(imp$vars)) # Factorize variable names
# Custom dotchart for Mean Decrease Accuracy
dotchart(
  imp$MeanDecreaseAccuracy, 
  labels = imp$vars, 
  xlim = c(-1, max(imp$MeanDecreaseAccuracy)), 
  pch = 16, 
  cex = 1.5,         # Adjust size of points
  cex.axis = 1.5,    # Adjust size of axis numbers
  cex.lab = 1.5      # Adjust size of axis labels
)

