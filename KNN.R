charity <- read.csv("./charity.csv")
str(charity)

library(dplyr)

####################################################################################
#
#                     Transformations
#
####################################################################################

library(caret)

charity.bc <- select(charity, -c(ID, donr, damt, part))

charity.bc.obj <- preProcess(charity.bc, method = "BoxCox") 
            
charity.bc.obj$bc

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


# set up data for analysis

data.train <- charity.t[charity$part == "train", ]
x.train <- data.train[ , 2:21]
c.train <- data.train[ , 22] # donr
n.train.c <- length(c.train) # 3984
y.train <- data.train[c.train == 1, 23] # damt for observations with donr=1
n.train.y <- length(y.train) # 1995

data.valid <- charity.t[charity$part=="valid",]
x.valid <- data.valid[,2:21]
c.valid <- data.valid[,22] # donr
n.valid.c <- length(c.valid) # 2018
y.valid <- data.valid[c.valid==1,23] # damt for observations with donr=1
n.valid.y <- length(y.valid) # 999


data.test <- charity.t[charity$part=="test",]
n.test <- dim(data.test)[1] # 2007
str(n.test)
x.test <- data.test[,2:21]
str(x.test)

x.train.mean <- apply(x.train, 2, mean)
x.train.sd <- apply(x.train, 2, sd)
x.train.std <- t((t(x.train)-x.train.mean)/x.train.sd) # standardize to have zero mean and unit sd
apply(x.train.std, 2, mean) # check zero mean
apply(x.train.std, 2, sd) # check unit sd
data.train.std.c <- data.frame(x.train.std, donr=c.train) # to classify donr
data.train.std.y <- data.frame(x.train.std[c.train==1,], damt=y.train) # to predict damt when donr=1

x.valid.std <- t((t(x.valid)-x.train.mean)/x.train.sd) # standardize using training mean and sd
data.valid.std.c <- data.frame(x.valid.std, donr=c.valid) # to classify donr
data.valid.std.y <- data.frame(x.valid.std[c.valid==1,], damt=y.valid) # to predict damt when donr=1

x.test.std <- t((t(x.test)-x.train.mean)/x.train.sd) # standardize using training mean and sd
data.test.std <- data.frame(x.test.std)

  
####################################################################################
#
#                          K-nearest Neighbors - Full
#
####################################################################################

library(class)

# The conventional wisdom is to set k as the square root of n.
sqrt(nrow(x.train.std))

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
which.min(knnmean)
k_seq[which.min(knnmean)]

# Run knn using the best value of k
knn.pred <- knn(x.train.std, x.valid.std, c.train, k = 17)

# Separate donors from non-donors
profit.knn <- cumsum(14.5 * c.valid[order(knn.pred, decreasing = T)] - 2)
plot(profit.knn)
n.mail.valid <- which.max(profit.knn)
c(n.mail.valid, max(profit.knn))
# [1]  1291.0 11120.5

table(knn.pred, c.valid)
#          c.valid
#knn.pred   0   1
#       0 677  48
#       1 342 951
# check n.mail.valid = 342 + 951 = 1291
# check profit = 14.5*951-2*1293 = 11203.5

####################################################################################
#
#                          K-nearest Neighbors - Reduced
#
####################################################################################


#chld, reg2, wrat, incm, tgif, home, plow, npro, inca, tlag

x.train.std.reduced <- select(as.data.frame(x.train.std), chld, chld, reg2, wrat, incm, tgif, home, plow, npro, inca, tlag) 
str(x.train.std.reduced)
x.valid.std.reduced <- select(as.data.frame(x.valid.std), chld, chld, reg2, wrat, incm, tgif, home, plow, npro, inca, tlag) 
str(x.valid.std.reduced)

# The conventional wisdom is to set k as the square root of n.
sqrt(nrow(x.train.std.reduced))

# We are going to iterate through 1 - 63 (the square root of n) using odd numbers
# to break any ties
k_seq <- seq(1, 63, 2)

# Create a container to hold the validation errors
knnmean <- rep(0, 32)

# Iterate through values of k = 1 through k = 63
for (i in 1:length(k_seq)) {
  set.seed(1)
  knn.pred <- knn(x.train.std.reduced, x.valid.std.reduced, c.train, k = i)
  knnmean[i] <- mean(knn.pred != c.valid)
}

# Which k provided the lowest validation error
which.min(knnmean)
k_seq[which.min(knnmean)]

# Run knn using the best value of k
knn.pred <- knn(x.train.std.reduced, x.valid.std.reduced, c.train, k = 61)

# Separate donors from non-donors
profit.knn <- cumsum(14.5 * c.valid[order(knn.pred, decreasing = T)] - 2)
plot(profit.knn)
n.mail.valid <- which.max(profit.knn)
c(n.mail.valid, max(profit.knn))
# [1]  1141.0 10637.5

table(knn.pred, c.valid)
#          c.valid
#knn.pred   0   1
#       0 677  48
#       1 342 951
# check n.mail.valid = 342 + 951 = 1291
# check profit = 14.5*951-2*1293 = 11203.5

