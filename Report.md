#### Introduction

A charitable organization wishes to develop a data-mining model to improve the cost-effectiveness of their direct marketing campaigns to previous donors. According to their recent mailing records, the typical overall response rate is 10%. Out of those who respond (donate), the average donation is $14.50. Each mailing, which includes a gift of personalized address labels and assortments of cards and envelopes, costs $2 to produce and send. Since expected profit from each mailing is 14.5 x 0.1 – 2 = –$0.55, it is not cost effective to mail everyone. 

The task is twofold:

1. Develop a classification model that can effectively capture likely donors so that the expected net profit is maximized. 

2. Develop a prediction model that predicts donation amounts from those people identified as donors.

The entire dataset consists of 8009 observations. These were subsetted into 3984 training observations, 2018 validation observations, and 2007 test observations. Weighted sampling was used to over-represent the responders so that the training and validation samples had approximately equal numbers of donors and non-donors. The response rate in the test sample has the more typical 10% response rate. 

Team H evaluated five different classification techniques to capture likely donors: k-nearest neighbor, random forests, logistic regression, linear discriminant analysis, and support vector machines. 

We evaluated five different regression techniques to predict likely donation amounts: ordinary least squares (OLS) regression, best subset regression, ridge regression, LASSO, and Partial Least Square (PLS).

Appendix A contains a complete description of the data.

Appendix B contains a description of the pre-processing of the data, as well as the R code used.

Appendix C contains an in-depth discussion of the various analytic evalution techniques used, as well as the R code used.

Appendix D contains a complete system description (i.e., hardware, operating system, R version, and R packages) with which the analysis was done.
 
#### Analysis

##### Pre-processing

A detailed discussion of pre-processing is contained in Appendix B. Of note, the `preProcessing()` function from the `caret` package [Kuhn, 2016] was used to perform Box-Cox analyses and develop transformation parameters for a number of variables. 

The data set was divided into three subsets: (1) a test subset with 3984 observations, (2) a validation subset with 2018 observations, and (3) a test subset with 2007 observations.

Following the subsetting, scaling was done on all variables using the R `scale()` function to achieve mean of 0 and standard deviation of 1.

##### Classification 

The following five classification techniques were evaluated: k-nearest neighbor, random forests, logistic regression, linear discriminant analysis, and support vector machines. Feature selection was performed beforehand, and the same features used for each classification evaluation.

###### Feature Selection

Feature selection was accomplished using a combination of the base R `cor()` function along with the `caret` package `trainControl()`, `rfeControl()`, and `varImport()` functions. From this analysis, the following 10 features were selected for the classification models: chld, reg2, wrat, incm, tgif, home, plow, npro, inca, tlag. 

The specific code, along with the associated discussion, used to determine these features is found on pages _____ and ____ in Appendix C.

###### K-nearest Neighbors (KNN)

For KNN [Venerables, 2002], we used leave-one-out cross validation method to find the optimal K for our model. We first tested k values from 1 to 300 in the interval of 10 using the training data and found that the minimum error rate occurred at k=11 (error rate increases from K=11 to k=51, then decreases about halfway from k=51 to k=100, and stabilizes throughout k=300). From there, we then tested k=1 through k=30 and found that the minimal error rate occurred at k=13 – as shown in Figure 4. Using K=13 for our KNN model, our validation error rate turned out to be 5.15%

###### Decision Trees

Our decision tree choice was a Random Forest [Liaw, 2002]. 

###### Logistic Regression


###### Linear Discriminant Analysis

[Venerables, 2002]

###### Support Vector Machines (SVM)

The SVM function used for prediction was from the e1071 package [Meyer et al, 2015].

##### Regression

###### Feature Selection

###### Ordinary Least Squares

###### Ridge Regression

###### LASSO

###### Non-Linear Methods



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

| Method        | Predicted Donations | Mean Prediction Error | Standard Error| Number of Features |
| ------------- | ----------------- |------------------------ | --------------| ------------------ |
| Ordinary Least Squares  | blah blah | blah blah  |   blah blah | blah blah |
| Best Subset  | blah blah  | blah blah | blah blah  | blah blah |
| Ridge Regression | blah blah | blah blah | blah blah | blah blah |
| LASSO | blah blah | blah blah | blah blah | blah blah |
| Partial Least Squares | blah blah | blah blah | blah blah | blah blah |  
| Boosting | blah blah | blah blah | blah blah | blah blah |

#### Conclusion

The ____ classification model did the best job of capturing likely donors, and therefore maximizing profit from the mailings. This model suggests that _____ letters will produce a profit of _____.

The ____ regression model did the best job of predicting the amount of donations based on donors. This model suggests that donations in the amount of ______ can be expected, with a prediction error of _______ and a standard error of ________.

#### References

Kuhn, M. (2016). caret: Classification and Regression Training. R package version 6.0-68.   
https://CRAN.R-project.org/package=caret  

Liaw, A. and M. Wiener (2002). Classification and Regression by randomForest. R News 2(3), 18--22  

Meyer, D. and Evgenia Dimitriadou, Kurt Hornik, Andreas Weingessel and Friedrich Leisch (2015). e1071:
Misc Functions of the Department of Statistics, Probability Theory Group (Formerly: E1071), TU Wien. R package version 1.6-7. https://CRAN.R-project.org/package=e1071


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

```
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
```  

#### Appendix B - R Code for Pre-Processing

The pre-processing of the data consisted of the following steps:

1. Examining for missing data
2. Exploratory data analysis and variable transformation
3. Creating training, validation, and test sets
4. Variable scaling
5. Feature selection

##### Missing Data

The following code was used to examine the data for missing data:

```colnames(charity)[colSums(is.na(charity)) > 0]```

This showed that the only two columns with missing data were `donr` and `damt`, both of which were response variables and would be dealt with in the actual analysis process.

##### EDA and Variable Transformation

```
# install.packages("caret", dependencies = c("Depends", "Suggests")
# library(caret)
# library(dplyr)

# Create a temporary data set without response variables
charity.bc <- select(charity, -(ID, donr, damt, part))

# Apply BoxCox method to identify transformations
charity.bc.obj <- preProcess(charity.bc, method = "BoxCox") 

# Print transformations
charity.bc.obj$bc
```

```
# Transform variables in accordance with Box Cox output
charity.t <- charity
charity.t$avhv <- log(charity.t$avhv)
charity.t$incm <- log(charity.t$incm)
charity.t$inca <- log(charity.t$inca)
charity.t$plow <- (charity.t$plow) ^ 0.3
charity.t$npro <- (charity.t$npro) ^ 0.6
charity.t$tgif <- (charity.t$tgif) ^ -0.3
charity.t$lgif <- log(charity.t$lgif)
charity.t$rgif <- log(charity.t$rgif)
charity.t$tdon <- log(charity.t$tdon)
charity.t$tlag <- (charity.t$tlag) ^ -0.4
charity.t$agif <- log(charity.t$agif)
```

##### Creating Test, Validation, and Training Sets

```
#
#     Create the training set
#
# Subset data on "part == train"
data.train <- charity.t[charity$part == "train", ]
# Create the training set design matrix, leaving out ID, donr, and damt
x.train <- data.train[ , 2:21]
# Create the response variable for the classification (donr)
c.train <- data.train[ , 22] # donr
# Determine number of elements in the classification response variable
n.train.c <- length(c.train) # 3984
# Create the response variable for the regression
y.train <- data.train[c.train == 1, 23] # damt for observations with donr = 1
# Determine the number of elements the regression response variable
n.train.y <- length(y.train) # 1995

#
#     Create the validation set
#
# Subset data on "part == valid"
data.valid <- charity.t[charity$part == "valid", ]
# Create the validation set design matrix, leaving out ID, donr, and damt
x.valid <- data.valid[ , 2:21]
# Create the response variable for the classification (donr)
c.valid <- data.valid[ , 22] # donr
# Determine the number of elements in the classification response variable
n.valid.c <- length(c.valid) # 2018
# Create the response variable for the regression
y.valid <- data.valid[c.valid == 1, 23] # damt for observations with donr=1
# Determine the number of elements in the regression response variable
n.valid.y <- length(y.valid) # 999

#
#     Create the test set
#
# Subset data on "part == test"
data.test <- charity.t[charity$part == "test", ]
# Determine the number of rows in the test data
n.test <- dim(data.test)[1] # 2007
# Create a test set design matrix, leaving out ID, donr, and damt
x.test <- data.test[ , 2:21]
```

##### Variable Scaling

```
#
#     Standardize the training data
#
# Find the mean of each column in the training design matrix
x.train.mean <- apply(x.train, 2, mean)
# Find the standard deviation of each column in the training design matrix
x.train.sd <- apply(x.train, 2, sd)
# Standardize each column in the training design matrix
x.train.std <- t((t(x.train)-x.train.mean)/x.train.sd) # standardize to have zero mean and unit sd
# Check that each column in the training design matrix has zero mean
apply(x.train.std, 2, mean) # check zero mean
# Check that each column in the training design matrix has a standard deviation of 1
apply(x.train.std, 2, sd) # check unit sd

#
#     Create data frames from standardized training data for donr and damt
#
# Create a training donr data frame with standardized data and the donr vector
data.train.std.c <- data.frame(x.train.std, donr=c.train) # to classify donr
# Create a training damt data frame with standardized data and the damt vector
data.train.std.y <- data.frame(x.train.std[c.train==1,], damt=y.train) # to predict damt when donr=1

#
#    Standardize the validation data
#
# Standardize the validation set using the training mean and training sd;
# Create a matrix and transpose it
x.valid.std <- t((t(x.valid)-x.train.mean)/x.train.sd) # standardize using training mean and sd
# Create validation donr data frame with standardized validation data
data.valid.std.c <- data.frame(x.valid.std, donr=c.valid) # to classify donr
# Create a validation damt data frame with standardized validation data
data.valid.std.y <- data.frame(x.valid.std[c.valid==1,], damt=y.valid) # to predict damt when donr=1

#
#     Standardize the test data
#
# Standardize the test set using the training mean and training sd;
# Create a matrix and transpose it
x.test.std <- t((t(x.test)-x.train.mean)/x.train.sd) # standardize using training mean and sd
# Create a data frame from the transposed matrix
data.test.std <- data.frame(x.test.std)
```

##### Feature Selection

#### Appendix C - R Code for Analysis

#### Appendix D - System

```
> sessionInfo()
R version 3.2.4 (2016-03-10)
Platform: x86_64-apple-darwin13.4.0 (64-bit)
Running under: OS X 10.9.5 (Mavericks)

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] e1071_1.6-7 MASS_7.3-45

loaded via a namespace (and not attached):
[1] class_7.3-14 tools_3.2.4 
```
