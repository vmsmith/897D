#### Introduction

The landscape of protein-protein interaction (PPI) is essential for developing cancer therapeutic approaches. However, it is not easy to directly measure PPI by quantifying protein levels and their activities in cells; hence, to be able to predict/infer PPI based on gene expression measurements, much easier to obtain, would be highly beneficial to the cancer community. The goal of project is to identify interacted genes by using gene expression data. The dataset contains 8,759 data points (where each data point represents a pair of genes). Each data point contains five predictors – the mean of each gene (X1, X2), the covariance of the two genes (X3), and the variance of each gene (X4, X5); and one binary response - 1 for interaction indication and 0 for no interaction (Y).


The project conducted five classification techniques – logistic regression, linear discriminant analysis (LDA), quadratic discriminant analysis (QDA), K-Nearest Neighbor (KNN), and Logistic Regression Generalized Additive Model (GAM). The dataset is split into 7,381 points for training and 1,378 for validation. Per instruction, we used set.seed(2014) for random number generator to allow reproducibility. We trained the model using the training set exclusively and tested the result on the validation set. Finally, we looked at various performance metrics in order to assess each model’s accuracy.

#### Analysis

##### Pre-processing

[Kuhn, 2016]

##### Regression

###### Feature Selection

###### Ordinary Least Squares

###### Ridge Regression

###### LASSO

###### Non-Linear Methods

##### Classification 

###### Feature Selection

###### Linear Discriminant Analysis

[Venerables, 2002]

###### Logistic Regression

###### K-nearest Neighbors

[Venerables, 2002]

###### Decision Trees

[Liaw, 2002]

###### Support Vector Machines

#### Results

#### Conclusion

#### References

Kuhn, M. (2016). caret: Classification and Regression Training. R package version 6.0-68.   
https://CRAN.R-project.org/package=caret  

Liaw, A. and M. Wiener (2002). Classification and Regression by randomForest. R News 2(3), 18--22  

Venables, W. N. & Ripley, B. D. (2002) Modern Applied Statistics with S. Fourth Edition. Springer, New York. ISBN 0-387-95457-0  


#### Appendix A - Data

#### Appendix B - R Code for Pre-Processing

#### Appendix C - R Code for Analysis

#### Appendix D - System
