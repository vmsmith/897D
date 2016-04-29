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

* ID number [Do NOT use this as a predictor variable in any models]
* EG1, REG2, REG3, REG4: Region (There are five geographic regions; only four are needed for analysis since if a potential donor falls into none of the four he or she must be in the other region. Inclusion of all five indicator variables would be redundant and cause some modeling techniques to fail. A “1” indicates the potential donor belongs to this region.)
* HOME: (1 = homeowner, 0 = not a homeowner)
* CHLD: Number of children
* HINC: Household income (7 categories)
* GENF: Gender (0 = Male, 1 = Female)
* WRAT: Wealth Rating (Wealth rating uses median family income and population statistics from each area to index relative wealth within each state. The segments are denoted 0-9, with 9 being the highest wealth group and 0 being the lowest.)
* AVHV: Average Home Value in potential donor's neighborhood in $ thousands
* INCM: Median Family Income in potential donor's neighborhood in $ thousands
* INCA: Average Family Income in potential donor's neighborhood in $ thousands
* PLOW: Percent categorized as “low income” in potential donor's neighborhood
* NPRO: Lifetime number of promotions received to date
* TGIF: Dollar amount of lifetime gifts to date
* LGIF: Dollar amount of largest gift to date
* RGIF: Dollar amount of most recent gift
* TDON: Number of months since last donation
* TLAG: Number of months between first and second gift
* AGIF: Average dollar amount of gifts to date
* DONR: Classification Response Variable (1 = Donor, 0 = Non-donor)
* DAMT: Prediction Response Variable (Donation Amount in $)


#### Appendix B - R Code for Pre-Processing

#### Appendix C - R Code for Analysis

#### Appendix D - System
