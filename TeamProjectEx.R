charity <- read.csv("./charity.csv")
dim(charity)
str(charity)
colnames(charity)[colSums(is.na(charity)) > 0]

####################################################################################
#
#                     Predictor transformations
#
####################################################################################

# install.packages("caret", dependencies = c("Depends", "Suggests")
# library(caret)
# library(dplyr)

# Create a temporary data set without response variables
charity.bc <- select(charity, -(ID, donr, damt, part))

# Apply BoxCox method to identify transformations
charity.bc.obj <- preProcess(charity.bc, method = "BoxCox") 

# Print transformations
charity.bc.obj$bc

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

####################################################################################
#
#                          Set up data for analysis
#
####################################################################################

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

####################################################################################
#
#             Data Preparation for Feature Selection
#
####################################################################################

#Prepare data for classification feature selection
data.train.std.c.x = data.train.std.c[,-21]
data.train.std.c.y = as.factor(data.train.std.c$donr)
data.valid.std.c.x = data.valid.std.c[,-21]
data.valid.std.c.y = as.factor(data.valid.std.c$donr)

#Prepare data for regression feature selection
data.train.std.y.x = data.train.std.y[,-21]
data.train.std.y.y = as.factor(data.train.std.y$damt)
data.valid.std.y.x = data.valid.std.y[,-21]
data.valid.std.y.y = as.factor(data.valid.std.y$damt)

# Create classification variable for classification tree
Donor=ifelse(c.train==1,"D","ND")
Donor.frame=data.frame(data.train.std.c,Donor)
Donor.valid=ifelse(c.valid==1,"D","ND")
Donor.frame.valid=data.frame(data.valid.std.c,Donor.valid)


####################################################################################
#
#           Classification Modeling - Linear Discriminant Analysis
#
####################################################################################

library(MASS)

# Fit a model using all variables and the standardized training data
model.lda1 <- lda(donr ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + I(hinc^2) + genf + wrat + 
                    avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                  data.train.std.c) # include additional terms on the fly using I()

# Note: strictly speaking, LDA should not be used with qualitative predictors,
# but in practice it often is if the goal is simply to find a good predictive model


# For each observation, the LDA predict function produces a list with three items: (1) a class, 
# (2) the posterior probability of the class, and (3) the LDA score (irrelevant for this problem).

# The posterior probability has two components: (1) the posterior probability of not being in the class, 
# (2) the posterior probability of being in the class.

# This code gives us the posterior probability of each observation in the validation set belonging 
# to the class it was predicted to be in

post.valid.lda1 <- predict(model.lda1, data.valid.std.c)$posterior[ , 2] # n.valid.c post probs

#
#     Calculate ordered profit function using average donation = $14.50 and mailing cost = $2
#
# This function begins by ordering the posterior probabilities in decreasing order:
#      order(post.valid.lda1, decreasing = T)
# Using the output of step 1 as an index, it isolates actual donors in the validation set:
#     c.valid[order(post.valid.lda1, decreasing = T)]
# It multiplies each result by $14.50 (the average donation), then subtracts 2
#     14.5 * c.valid[order(post.valid.lda1, decreasing = T)] - 2 (the cost of mailing)
# Finally, it calculates the cumulative sum and saves each cumulative sum to profit.lda1
# Note 1: the order() function behaves slightly differently than the sort() function used in a few lines
# Note 2: This is actually a series of $12.50 add-ons, until a certain point, and then it is 
#         cumulative $2.00 subtractions.

profit.lda1 <- cumsum(14.5 * c.valid[order(post.valid.lda1, decreasing = T)] - 2)

# Show how profits increase, peak, and then decline with more mailings
plot(profit.lda1) 
# Identifies the maximum profit point
n.mail.valid <- which.max(profit.lda1)
# Identifies the maximum profit point and associated profit
c(n.mail.valid, max(profit.lda1)) 
# 1329.0 11624.5

#
#     Sets a cutoff point based on the maximum that was just calculated
#
# Sorts the posterior probabilities in decreasing order
# Creates a cutoff point using the maximum that was calculated (n.mail.valid) + 1
cutoff.lda1 <- sort(post.valid.lda1, decreasing = T)[n.mail.valid + 1] 

# Subsets the posterior probabilities based on the cutoff point
# Everyone above the cutoff is a candidate for mailing
chat.valid.lda1 <- ifelse(post.valid.lda1 > cutoff.lda1, 1, 0) 

# Creates classification matrix
table(chat.valid.lda1, c.valid)
#               c.valid
#chat.valid.lda1   0   1
#              0 675  14
#              1 344 985
# check n.mail.valid = 344 + 985 = 1329
# check profit = 14.5 * 985 - 2 * 1329 = 11624.5


####################################################################################
#
#                 Classification Modeling - Logistic Regression
#
####################################################################################

# Fit a model using all variables and the standardized training data
model.log1 <- glm(donr ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + I(hinc^2) + genf + wrat + 
                    avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                  data.train.std.c, family=binomial("logit"))

# Make a prediction using the fitted glm model and the standardized validation data
# This produces a vector of probabilities
post.valid.log1 <- predict(model.log1, data.valid.std.c, type="response") # n.valid post probs

#
#     Calculate ordered profit function using average donation = $14.50 and mailing cost = $2
#     Identical to LDA
#
# This function begins by ordering the posterior probabilities in decreasing order:
#      order(post.valid.lda1, decreasing = T)
# Using the output of step 1 as an index, it isolates actual donors in the validation set:
#     c.valid[order(post.valid.lda1, decreasing = T)]
# It multiplies each result by $14.50 (the average donation), then subtracts 2
#     14.5 * c.valid[order(post.valid.lda1, decreasing = T)] - 2 (the cost of mailing)
# Finally, it calculates the cumulative sum and saves each cumulative sum to profit.log1
# Note 1: the order() function behaves slightly differently than the sort() function used in a few lines
# Note 2: This is actually a series of $12.50 add-ons, until a certain point, and then it is 
#         cumulative $2.00 subtractions.
profit.log1 <- cumsum(14.5 * c.valid[order(post.valid.log1, decreasing = T)] - 2)

# Show how profits increase, peak, and then decline with more mailings
plot(profit.log1) # see how profits change as more mailings are made
# Identifies the maximum profit point
n.mail.valid <- which.max(profit.log1) # number of mailings that maximizes profits
# Identifies the maximum profit point and associated profit
c(n.mail.valid, max(profit.log1)) # report number of mailings and maximum profit
# 1291.0 11642.5

#
#     Sets a cutoff point based on the maximum that was just calculated
#
# Sorts the posterior probabilities in decreasing order
# Indexes the sorted list using the maximum that was calculated
cutoff.log1 <- sort(post.valid.log1, decreasing = T)[n.mail.valid + 1] # set cutoff based on n.mail.valid
# Subsets the posterior probabilities based on the index
chat.valid.log1 <- ifelse(post.valid.log1>cutoff.log1, 1, 0) # mail to everyone above the cutoff
# Computes confusion matrix
table(chat.valid.log1, c.valid) # classification table
#               c.valid
#chat.valid.log1   0   1
#              0 709  18
#              1 310 981
# check n.mail.valid = 310+981 = 1291
# check profit = 14.5*981-2*1291 = 11642.5

# Results

# n.mail Profit  Model
# 1329   11624.5 LDA1
# 1291   11642.5 Log1

####################################################################################
#
#                   Classification Modeling - K-nearest Neighbors
#
####################################################################################

library(class)

# The conventional wisdom is to set k as the square root of n.
sqrt(nrow(x.train.std)) # = 63.11894

# We are going to iterate through 1 - 63 (the square root of n) using odd numbers
# to break any ties
k_seq <- seq(1, 63, 2)

# Create a container to hold the validation errors
knnmean <- rep(0, 32)

# Iterate through values of k = 1 through k = 63
for (i in 1:length(k_seq)) {
  set.seed(1)
  knn.pred <- knn(x.train.std, x.valid.std, c.train, k = i)
  knnmean[i] <- mean(knn.pred != c.valid)
}

# Which k provided the lowest validation error
which.min(knnmean) # 10
k_seq[which.min(knnmean)] # 19

# Run the knn prediction function using the best value of k
knn.pred <- knn(x.train.std, x.valid.std, c.train, k = 19)

#
#     Calculate ordered profit function using average donation = $14.50 and mailing cost = $2
#     Similar, but not identical to, LDA and Logistic Regression
#
# This function begins by ordering the posterior probabilities -- 1s and 0s -- in decreasing order:
#      order(post.valid.lda1, decreasing = T)
# Using the output of step 1 as an index, it isolates actual donors in the validation set:
#     c.valid[order(post.valid.lda1, decreasing = T)]
# It multiplies each result by $14.50 (the average donation), then subtracts 2
#     14.5 * c.valid[order(post.valid.lda1, decreasing = T)] - 2 (the cost of mailing)
# Finally, it calculates the cumulative sum and saves each cumulative sum to profit.knn
# Note 1: the order() function behaves slightly differently than the sort() function used in a few lines
# Note 2: This is actually a series of $12.50 add-ons, until a certain point, and then it is 
#         cumulative $2.00 subtractions.
profit.knn <- cumsum(14.5 * c.valid[order(knn.pred, decreasing = T)] - 2)

# Show how profits increase, peak, and then decline with more mailings
plot(profit.knn)

# Identifies the maximum profit point
n.mail.valid <- which.max(profit.knn)

# Identifies the maximum profit point and associated profit
c(n.mail.valid, max(profit.knn))

# Because knn produces either a 1 (donor) or 0 (non-donor) we do not need to order and use posterior
# probabilities per se

table(knn.pred, c.valid)
#          c.valid
#knn.pred   0   1
#       0 677  48
#       1 342 951
# check n.mail.valid = 342 + 951 = 1291
# check profit = 14.5*951-2*1293 = 11203.5

####################################################################################
#
#     Classification Modeling - Support Vector Machines - Preparation
#
####################################################################################

library(e1071)

# Change donr to a class to avoid getting negative probabilities
data.train.std.c$donr[data.train.std.c$donr == 1] <- "D"
data.train.std.c$donr[data.train.std.c$donr == 0] <- "N"

data.valid.std.c$donr[data.valid.std.c$donr == 1] <- "D"
data.valid.std.c$donr[data.valid.std.c$donr == 0] <- "N"

####################################################################################
#
#       Classification Modeling - Support Vector Machines - Linear Kernel
#
####################################################################################

# Fit a model using all variables and the standardized training data
svmtrain1 <- svm(donr ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + I(hinc^2) + genf + wrat + 
                   avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                 data.train.std.c, kernel = "linear", cost = 0.01, type = "C", probability = TRUE)


# Tune to find optimum cost and gamma parameters
#
#     Note: This does not work yet
#
set.seed(1)
tune.out1 <- tune(svm, donr ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + I(hinc^2) + genf + wrat + 
                  avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                  data.train.std.c, kernel = "linear", type = "C", probability = TRUE, 
                  ranges = list(cost = 10^seq(-2, 1, by = 0.1)))
summary(tune.out1)
tune.out1$best.parameters



# For each observation, the SVM predict function produces posterior probabilities that can be
# accessed through the attr() function. The second column of attr(post.valid.svm1, "probabilities")
# contains the posterior probability of an observation belonging to the donor class

post.valid.svm1 <- predict(svmtrain1, newdata = data.valid.std.c, type = "prob", probability = TRUE) 

# Capture the posterior probabilities
post.valid.svm1 <- attr(post.valid.svm1, "probabilities")[ , 2]

#
#     Calculate ordered profit function using average donation = $14.50 and mailing cost = $2
#
# This function begins by ordering the posterior probabilities in decreasing order:
#      order(post.valid.lda1, decreasing = T)
# Using the output of step 1 as an index, it isolates actual donors in the validation set:
#     c.valid[order(post.valid.lda1, decreasing = T)]
# It multiplies each result by $14.50 (the average donation), then subtracts 2
#     14.5 * c.valid[order(post.valid.lda1, decreasing = T)] - 2 (the cost of mailing)
# Finally, it calculates the cumulative sum and saves each cumulative sum to profit.lda1
# Note 1: the order() function behaves slightly differently than the sort() function used in a few lines
# Note 2: This is actually a series of $12.50 add-ons, until a certain point, and then it is 
#         cumulative $2.00 subtractions.

profit.svm1 <- cumsum(14.5 * c.valid[order(post.valid.svm1, decreasing = T)] - 2)

# Show how profits increase, peak, and then decline with more mailings
plot(profit.svm1) 
# Identifies the maximum profit point
n.mail.valid <- which.max(profit.svm1)
# Identifies the maximum profit point and associated profit
c(n.mail.valid, max(profit.svm1)) 
# 1389.0 11635

#
#     Sets a cutoff point based on the maximum that was just calculated
#
# Sorts the posterior probabilities in decreasing order
# Creates a cutoff point using the maximum that was calculated (n.mail.valid) + 1
cutoff.svm1 <- sort(post.valid.svm1, decreasing = T)[n.mail.valid + 1] 

# Subsets the posterior probabilities based on the cutoff point
# Everyone above the cutoff is a candidate for mailing
chat.valid.svm1 <- ifelse(post.valid.svm1 > cutoff.svm1, 1, 0) 

# Creates classification matrix
table(chat.valid.svm1, c.valid)
#               c.valid
#chat.valid.svm1   0   1
#              0 624   5
#              1 395 994
# check n.mail.valid = 395 + 994 = 1389
# check profit = 14.5 * 985 - 2 * 1329 = 11624.5

####################################################################################
#
#       Classification Modeling - Support Vector Machines - Radial Kernel
#
####################################################################################

library(e1071)

# Fit a model using all variables and the standardized training data
svmtrain2 <- svm(donr ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + I(hinc^2) + genf + wrat + 
                   avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                 data.train.std.c, kernel = "radial", cost = 0.01, type = "C", probability = TRUE)


# For each observation, the SVM predict function produces posterior probabilities that can be
# accessed through the attr() function. The second column of attr(post.valid.svm1, "probabilities")
# contains the posterior probability of an observation belonging to the donor class

post.valid.svm2 <- predict(svmtrain2, newdata = data.valid.std.c, type = "prob", probability = TRUE) 

# Capture the posterior probabilities
post.valid.svm2 <- attr(post.valid.svm2, "probabilities")[ , 2]

#
#     Calculate ordered profit function using average donation = $14.50 and mailing cost = $2
#
# This function begins by ordering the posterior probabilities in decreasing order:
#      order(post.valid.lda1, decreasing = T)
# Using the output of step 1 as an index, it isolates actual donors in the validation set:
#     c.valid[order(post.valid.lda1, decreasing = T)]
# It multiplies each result by $14.50 (the average donation), then subtracts 2
#     14.5 * c.valid[order(post.valid.lda1, decreasing = T)] - 2 (the cost of mailing)
# Finally, it calculates the cumulative sum and saves each cumulative sum to profit.lda1
# Note 1: the order() function behaves slightly differently than the sort() function used in a few lines
# Note 2: This is actually a series of $12.50 add-ons, until a certain point, and then it is 
#         cumulative $2.00 subtractions.

profit.svm2 <- cumsum(14.5 * c.valid[order(post.valid.svm2, decreasing = T)] - 2)

# Show how profits increase, peak, and then decline with more mailings
plot(profit.svm2) 
# Identifies the maximum profit point
n.mail.valid <- which.max(profit.svm2)
# Identifies the maximum profit point and associated profit
c(n.mail.valid, max(profit.svm2)) 
# 1382.0 11489.5

#
#     Sets a cutoff point based on the maximum that was just calculated
#
# Sorts the posterior probabilities in decreasing order
# Creates a cutoff point using the maximum that was calculated (n.mail.valid) + 1
cutoff.svm2 <- sort(post.valid.svm2, decreasing = T)[n.mail.valid + 1] 

# Subsets the posterior probabilities based on the cutoff point
# Everyone above the cutoff is a candidate for mailing
chat.valid.svm2 <- ifelse(post.valid.svm2 > cutoff.svm2, 1, 0) 

# Creates classification matrix
table(chat.valid.svm2, c.valid)
#               c.valid
#chat.valid.svm1   0   1
#              0 620  16
#              1 399 983
# check n.mail.valid = 399 + 983 = 1382
# check profit = 14.5 * 985 - 2 * 1329 = 11624.5

####################################################################################
#
#       Classification Modeling - Support Vector Machines - Polynomial Kernel
#
####################################################################################

# Fit a model using all variables and the standardized training data
svmtrain3 <- svm(donr ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + I(hinc^2) + genf + wrat + 
                 avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                 data.train.std.c, kernel = "polynomial", degree = 2, cost = 0.01, type = "C", 
                 probability = TRUE)


# For each observation, the SVM predict function produces posterior probabilities that can be
# accessed through the attr() function. The second column of attr(post.valid.svm1, "probabilities")
# contains the posterior probability of an observation belonging to the donor class

post.valid.svm3 <- predict(svmtrain3, newdata = data.valid.std.c, type = "prob", probability = TRUE) 

# Capture the posterior probabilities
post.valid.svm3 <- attr(post.valid.svm3, "probabilities")[ , 2]

#
#     Calculate ordered profit function using average donation = $14.50 and mailing cost = $2
#
# This function begins by ordering the posterior probabilities in decreasing order:
#      order(post.valid.lda1, decreasing = T)
# Using the output of step 1 as an index, it isolates actual donors in the validation set:
#     c.valid[order(post.valid.lda1, decreasing = T)]
# It multiplies each result by $14.50 (the average donation), then subtracts 2
#     14.5 * c.valid[order(post.valid.lda1, decreasing = T)] - 2 (the cost of mailing)
# Finally, it calculates the cumulative sum and saves each cumulative sum to profit.lda1
# Note 1: the order() function behaves slightly differently than the sort() function used in a few lines
# Note 2: This is actually a series of $12.50 add-ons, until a certain point, and then it is 
#         cumulative $2.00 subtractions.

profit.svm3 <- cumsum(14.5 * c.valid[order(post.valid.svm3, decreasing = T)] - 2)

# Show how profits increase, peak, and then decline with more mailings
plot(profit.svm3) 
# Identifies the maximum profit point
n.mail.valid <- which.max(profit.svm3)
# Identifies the maximum profit point and associated profit
c(n.mail.valid, max(profit.svm3)) 
# 1689.0 10846.5

#
#     Sets a cutoff point based on the maximum that was just calculated
#
# Sorts the posterior probabilities in decreasing order
# Creates a cutoff point using the maximum that was calculated (n.mail.valid) + 1
cutoff.svm3 <- sort(post.valid.svm3, decreasing = T)[n.mail.valid + 1] 

# Subsets the posterior probabilities based on the cutoff point
# Everyone above the cutoff is a candidate for mailing
chat.valid.svm3 <- ifelse(post.valid.svm3 > cutoff.svm3, 1, 0) 

# Creates classification matrix
table(chat.valid.svm3, c.valid)
#               c.valid
#chat.valid.svm1   0   1
#              0 325  23
#              1 694 976
# check n.mail.valid = 694 + 976 = 1670
# check profit = 14.5 * 985 - 2 * 1329 = 11624.5


###################################################################################
#
#           Select the classification model and calculate mailings
#
###################################################################################

# Make a prediction using the fitted glm model and the standardized test data
# This produces a vector of posterior probabilities
post.test <- predict(model.log1, data.test.std, type="response") 

#
# Make the oversampling adjustment for calculating number of mailings for test set
#
# In the original data set, only 10% of the responders were donors. This was artificially changed to 50%
# through oversampling methods. This section accounts for that.
#
# Identifies the maximum profit point (should be the same as in logistic regression)
n.mail.valid <- which.max(profit.log1)

# Typical real world response rate is 0.1
tr.rate <- .1 
# Validation response rate is 0.5 via oversampling
vr.rate <- .5 
# Adjust for mail = yes
adj.test.1 <- (n.mail.valid/n.valid.c)/(vr.rate/tr.rate) 
# Adjust for mail = no
adj.test.0 <- ((n.valid.c-n.mail.valid)/n.valid.c)/((1-vr.rate)/(1-tr.rate)) 

# Create a scaled proportion
adj.test <- adj.test.1/(adj.test.1 + adj.test.0) # scale into a proportion
# Calculate the number of mailings in test set
n.mail.test <- round(n.test * adj.test, 0) # calculate number of mailings for test set

# Indexes the sorted list using the maximum that was calculated
cutoff.test <- sort(post.test, decreasing=T)[n.mail.test + 1] # set cutoff based on n.mail.test
# Subsets the posterior probabilities based on the index
chat.test <- ifelse(post.test > cutoff.test, 1, 0) # mail to everyone above the cutoff
# Displays 1s and 0s in a table
table(chat.test)
#    0    1 
# 1676  331
# based on this model we'll mail to the 331 highest posterior probabilities

# See below for saving chat.test into a file for submission

####################################################################################
#
#                         Regression Modeling
#
####################################################################################

# Fit a model using all variables and the standardized training data
model.ls1 <- lm(damt ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + genf + wrat + 
                  avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                data.train.std.y)

# Make a prediction using the fitted lm model and the standardized validation data
pred.valid.ls1 <- predict(model.ls1, newdata = data.valid.std.y) # validation predictions

# Compute the mean prediction error
mean((y.valid - pred.valid.ls1)^2) # mean prediction error
# 1.867523

# Compute the standard error
sd((y.valid - pred.valid.ls1)^2)/sqrt(n.valid.y) # std error
# 0.1696615

#
#     Drop wrat for illustrative purposes
#
# Simply list all variables except wrat
model.ls2 <- lm(damt ~ reg1 + reg2 + reg3 + reg4 + home + chld + hinc + genf + 
                  avhv + incm + inca + plow + npro + tgif + lgif + rgif + tdon + tlag + agif, 
                data.train.std.y)

# Make a prediction using the new fitted lm model and the standardized validation data
pred.valid.ls2 <- predict(model.ls2, newdata = data.valid.std.y) # validation predictions
# Compute the new mean prediction error
mean((y.valid - pred.valid.ls2)^2) # mean prediction error
# 1.867433

# Compute the new standard error
sd((y.valid - pred.valid.ls2)^2)/sqrt(n.valid.y) # std error
# 0.1696498

# Compare the mean prediction errors of the two models

# MPE  Model
# 1.867523 LS1
# 1.867433 LS2

###################################################################################
#
#           Select the regression model and calculate test results
#
###################################################################################

# Select model.ls2 since it has minimum mean prediction error in the validation sample

# Make a prediction using the selected fitted lm model and the standardized test data
yhat.test <- predict(model.ls2, newdata = data.test.std) # test predictions

###################################################################################
#
#           Save the final results for both classificatino and regression
#
###################################################################################


length(chat.test) # check length = 2007
length(yhat.test) # check length = 2007
chat.test[1:10] # check this consists of 0s and 1s
yhat.test[1:10] # check this consists of plausible predictions of damt

####################################################################################
#
#                         Write to a file for submission
#
####################################################################################


ip <- data.frame(chat = chat.test, yhat = yhat.test) # data frame with two variables: chat and yhat
write.csv(ip, file = "~/Documents/teaching/psu/ip.csv", 
          row.names = FALSE) # use group member initials for file name

# submit the csv file in Angel for evaluation based on actual test donr and damt values
