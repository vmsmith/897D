```{r}
charity <- read.csv("./charity.csv")
str(charity)
```

# home
hist(charity$home)

# chld
hist(charity$chld)

# hinc
hist(charity$hinc)

# genf
hist(charity$genf)

# wrat
hist(charity$wrat)

# avhv
hist(charity$avhv)

# incm
hist(charity$incm)

# inca
hist(charity$inca)

# plow
hist(charity$plow)

# npro
hist(charity$npro)

# tgif
hist(charity$tgif, breaks = 50)

# lgif
hist(charity$lgif, breaks = 50)

# rgif
hist(charity$rgif, breaks = 50)

# tdon
hist(charity$tdon)

# tlag
hist(charity$tlag)

# agif
hist(charity$agif)

