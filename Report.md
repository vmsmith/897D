#### Introduction

A charitable organization wishes to develop a data-mining model to improve the cost-effectiveness of their direct marketing campaigns to previous donors. According to their recent mailing records, the typical overall response rate is 10%. Out of those who respond (donate), the average donation is $14.50. Each mailing, which includes a gift of personalized address labels and assortments of cards and envelopes, costs $2 to produce and send. Since expected profit from each mailing is 14.5 x 0.1 – 2 = –$0.55, it is not cost effective to mail everyone. 

The task is twofold:

1. Develop a classification model that can effectively capture likely donors so that the expected net profit is maximized. 

2. Develop a prediction model that predicts donation amounts from those people identified as donors.

Team H evaluated five different classification techniques to capture likely donors: k-nearest neighbor, random forests, logistic regression, linear discriminant analysi, and support vector machines. 

We evaluated __ different regression techniques to predict likely donation amounts: ordinary least squares regression, best subset regression, ridge regression, LASSO, and ________.

Appendix A contains a complete description of the data.

Appendix B contains a description of the pre-processing of the data, as well as the R code used.

Appendix C contains an in-depth discussion of the various analytic evalution techniques used, as well as the R code used.

Appendix D contains a complete system description (i.e., hardware, operating system, R version, and R packages) with which the analysis was done.

Appendix A describes the data.  
 
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
