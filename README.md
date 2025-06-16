# Random Forest Analysis for Methane Flux Prediction
This repository contains the R code used to perform a random forest analysis for predicting methane (CH₄) fluxes based on lake sediment, morphometric, landscape, and climatic variables. The analysis was conducted as part of a study on methane fluxes in lake ecosystems. The random forest analysis in this repository is implemented using the **`randomForest`** package for R, originally developed by **Leo Breiman** and **Adele Cutler**, and ported to R by **Andy Liaw and Matthew Wiener**. For more information about the package, please refer to the official documentation and citation:
- Liaw, A. and Wiener, M. (2002). Classification and Regression by randomForest. R News, 2(3), 18–22. [Link](https://cran.r-project.org/web/packages/randomForest/randomForest.pdf)
To cite the **`randomForest`** package in your work, use:
```R
citation("randomForest
---
## **Project Description**
The goal of this analysis is to:
- Use random forest regression to model methane fluxes based on predictor variables.
- Identify the most important variables influencing methane fluxes using variable importance metrics.
- Tune the random forest model to optimize performance and minimize error.
---
## **Files in This Repository**
- `randomforest_analysis.R`: The main R script containing the random forest analysis code.
- `README.md`: This file, providing an overview of the project.
- `dummy_dataset.csv`: A small example dataset for testing the code.
---
## **Dependencies**
The following R packages are required to run the code:
- `tidyr`
- `tidyverse`
- `randomForest`
- `GGally`
- `pdp`
- `cowplot`
- `ggpubr`
- `factoextra`
You can install these packages in R using:
```R
install.packages(c("tidyr", "tidyverse", "randomForest", "GGally", "pdp", "cowplot", "ggpubr", "factoextra"))
