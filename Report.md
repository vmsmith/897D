#### Introduction

A charitable organization wishes to develop a data-mining model to improve the cost-effectiveness of their direct marketing campaigns to previous donors. According to their recent mailing records, the typical overall response rate is 10%. Out of those who respond (donate), the average donation is $14.50. Each mailing, which includes a gift of personalized address labels and assortments of cards and envelopes, costs $2 to produce and send. Since expected profit from each mailing is 14.5 x 0.1 – 2 = –$0.55, it is not cost effective to mail everyone. 

The task is twofold:

1. Develop a classification model that can effectively capture likely donors so that the expected net profit is maximized. 

2. Develop a prediction model that predicts donation amounts from those people identified as donors.

Team H evaluated five different classification techniques to capture likely donors: k-nearest neighbor, random forests, logistic regression, linear discriminant analysis, and support vector machines. 

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

##### Classification Methods  

| Method        | Number of Letters | Predicted Profit|
| ------------- | ----------------- |---------------- |
| K-nearest Neighbor  | blah blah  |   blah blah      |
| Random Forest  | blah blah  | blah blah             |
| Logistic Regression | blah blah | blah blah |
| Linear Discriminant Analysis | blah blah | blah blah |
| Support Vector Machine | blah blah | blah blah |


##### Regression Methods  

| Method        | Mean Prediction Error | Standard Error|
| ------------- | ----------------- |---------------- |
| Ordinary Least Squares  | blah blah  |   blah blah      |
| Best Subset  | blah blah  | blah blah             |
| Ridge Regression | blah blah | blah blah |
| LASSO | blah blah | blah blah |
| Something non-linear | blah blah | blah blah |  

#### Conclusion

#### References

Kuhn, M. (2016). caret: Classification and Regression Training. R package version 6.0-68.   
https://CRAN.R-project.org/package=caret  

Liaw, A. and M. Wiener (2002). Classification and Regression by randomForest. R News 2(3), 18--22  

Venables, W. N. & Ripley, B. D. (2002) Modern Applied Statistics with S. Fourth Edition. Springer, New York. ISBN 0-387-95457-0  


#### Appendix A - Data

The data set, `charity.csv`, contained 8009 records, each with the following 24 variables:  

* ID number (not used as either a predictor or response variable)
* EG1, REG2, REG3, REG4: Region (There are five geographic regions; only four are needed for analysis since if a potential donor falls into none of the four he or she must be in the other region.)
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

A first examination of the structure of the data using the R `str()` command showed the following:

> str(charity)  
'data.frame':	8009 obs. of  24 variables:  
 $ ID  : int  1 2 3 4 5 6 7 8 9 10 ...  
 $ reg1: int  0 0 0 0 0 0 0 0 0 0 ...  
 $ reg2: int  0 0 0 0 0 1 0 0 0 0 ...  
 $ reg3: int  1 1 1 0 1 0 0 0 1 0 ...  
 $ reg4: int  0 0 0 0 0 0 0 0 0 0 ...  
 $ home: int  1 1 1 1 1 1 1 1 1 1 ...  
 $ chld: int  1 2 1 1 0 1 3 3 2 3 ...  
 $ hinc: int  4 4 5 4 4 5 4 2 3 4 ...  
 $ genf: int  1 0 1 0 1 0 0 0 1 1 ...  
 $ wrat: int  8 8 8 8 4 9 8 5 5 7 ...  
 $ avhv: int  302 262 303 317 295 114 145 165 194 200 ...  
 $ incm: int  76 130 61 121 39 17 39 34 112 38 ...  
 $ inca: int  82 130 90 121 71 25 42 35 112 58 ...  
 $ plow: int  0 1 6 0 14 44 10 19 0 5 ...  
 $ npro: int  20 95 64 51 85 83 50 11 75 42 ...  
 $ tgif: int  81 156 86 56 132 131 74 41 160 63 ...  
 $ lgif: int  81 16 15 18 15 5 6 4 28 12 ...  
 $ rgif: int  19 17 10 7 10 3 5 2 34 10 ...  
 $ tdon: int  17 19 22 14 10 13 22 20 14 19 ...  
 $ tlag: int  6 3 8 7 6 4 3 7 4 3 ...  
 $ agif: num  21.05 13.26 17.37 9.59 12.07 ...  
 $ donr: int  0 1 NA NA 1 1 0 0 NA 0 ...  
 $ damt: int  0 15 NA NA 17 12 0 0 NA 0 ...  
 $ part: Factor w/ 3 levels "test","train",..: 2 2 1 1 3 2 3 3 1 2 ...  

#### Appendix B - R Code for Pre-Processing

The pre-processing of the data consisted of the following steps:

1. Examining for missing data
2. Exploratory data analysis and variable transformation
3. Creating training, validation, and test sets
4. Variable scaling
5. Feature selection

##### Missing Data


##### EDA and Variable Transformation


##### Creating Test, Validation, and Training Sets


##### Variable Scaling


##### Feature Selection

#### Appendix C - R Code for Analysis

#### Appendix D - System
