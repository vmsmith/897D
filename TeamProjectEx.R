charity <- read.csv("~/Documents/teaching/psu/charity.csv")

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
# This function begins by ordering the posterior probabilities in decreasingn order.
# From each observation, it subtracts 2 (the cost of the mailing)
# It multiplies that by c.valid, which is either a 0 or a 1
# It multiplies that by 14.5, the average donation
# It calculates the cumulative sum and saves each cumulative sum to profit.lda1
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

###################################################################################
#
#           Select the classification model and calculate mailings
#
###################################################################################

# Make a prediction using the fitted glm model and the standardized test data
# This produces a vector of probabilities
post.test <- predict(model.log1, data.test.std, type="response") # post probs for test data

#
# Make the oversampling adjustment for calculating number of mailings for test set
#
# 
# Identifies the maximum profit point (should be the same as in logistic regression)
n.mail.valid <- which.max(profit.log1)
# Typical response rate
tr.rate <- .1 # typical response rate is .1
# Actual validation response rate
vr.rate <- .5 # whereas validation response rate is .5
# Adjust for mail = yes
adj.test.1 <- (n.mail.valid/n.valid.c)/(vr.rate/tr.rate) # adjustment for mail yes
# Adjust for mail = no
adj.test.0 <- ((n.valid.c-n.mail.valid)/n.valid.c)/((1-vr.rate)/(1-tr.rate)) # adjustment for mail no
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
