#### Exploratory Data Analysis files

![home](./figures/home_hist.png)

```{r}
charity <- read.csv("./charity.csv")
str(charity)
```

#### home  
(0 = not a homeowner, 1 = homeowner)  
```{r}
counts1 <- table(charity$home)
counts1
barplot(counts1, main = "home Barplot")
dev.copy(png,'./EDA/home_bar.png')
dev.off()
```
![home Barplot](./figures/home_bar.png)


#### chld  
Number of children  
```{r}
counts2 <- table(charity$chld)
counts2
barplot(counts2, main = "chld Barplot")
dev.copy(png,'./EDA/chld_bar.png')
dev.off()
```

#### hinc  
Household income (7 categories)  
```{r}
counts3 <- table(charity$hinc)
counts3
barplot(counts3, main = "hinc Barplot")
dev.copy(png,'./EDA/hinc_bar.png')
dev.off()
```


#### genf  
Gender (0 = Male, 1 = Female)  
```{r}
counts4 <- table(charity$genf)
counts4
barplot(counts4, main = "genf Barplot")
dev.copy(png,'./EDA/genf_bar.png')
dev.off()
```

#### wrat  
Wealth Rating (Wealth rating uses median family income and population statistics from each area to index relative wealth within each state. The segments are denoted 0-9, with 9 being the highest wealth group and 0 being the lowest.)  
```{r}
fivenum(charity$wrat)
hist(charity$wrat, main = "wrat Histogram")
dev.copy(png,'./EDA/wrat_hist.png')
dev.off()
counts5 <- table(charity$wrat)
counts5
barplot(counts5, main = "wrat Barplot")
dev.copy(png,'./EDA/wrat_bar.png')
dev.off()
```

#### avhv  
Average Home Value in potential donor's neighborhood in $ thousands  
```{r}
fivenum(charity$avhv)
boxplot(charity$avhv, main = "vhv Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/avhv_box.png')
dev.off()
hist(charity$avhv, main = "avhv Histogram", xlim = c(0, 700))
dev.copy(png,'./EDA/avhv_hist.png')
dev.off()
```

#### incm  
Median Family Income in potential donor's neighborhood in $ thousands  
```{r}
fivenum(charity$incm)
boxplot(charity$incm, main = "incm Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/incm_box.png')
dev.off()
hist(charity$incm, main = "incm Histogram")
dev.copy(png,'./EDA/incm_hist.png')
dev.off()
```

#### inca  
Average Family Income in potential donor's neighborhood in $ thousands  
```{r}
fivenum(charity$inca)
boxplot(charity$inca, main = "inca Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/inca_box.png')
dev.off()
hist(charity$inca, main = "inca Histogram")
dev.copy(png,'./EDA/inca_hist.png')
dev.off()
```

#### plow  
Percent categorized as “low income” in potential donor's neighborhood  
```{r}
fivenum(charity$plow)
boxplot(charity$plow, main = "plow Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/plow_box.png')
dev.off()
hist(charity$plow, main = "plow Histogram")
dev.copy(png,'./EDA/plow_hist.png')
dev.off()
```

#### npro  
Lifetime number of promotions received to date  
```{r}
fivenum(charity$npro)
boxplot(charity$npro, main = "npro Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/npro_box.png')
dev.off()
hist(charity$npro, main = "npro Histogram")
dev.copy(png,'./EDA/npro_hist.png')
dev.off()
```

#### tgif  
Dollar amount of lifetime gifts to date  
```{r}
fivenum(charity$tgif)
boxplot(charity$tgif, main = "tgif Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/tgif_box.png')
dev.off()
hist(charity$tgif, main = "tgif Histogram", breaks = 50)
dev.copy(png,'./EDA/tgif_hist.png')
dev.off()
```

#### lgif  
Dollar amount of largest gift to date  
```{r}
fivenum(charity$lgif)
boxplot(charity$lgif, main = "lgif Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/lgif_box.png')
dev.off()
hist(charity$lgif, main = "lgif Histogram", breaks = 50)
dev.copy(png,'./EDA/gif_hist.png')
dev.off()
```

#### rgif  
Dollar amount of most recent gift  
```{r}
fivenum(charity$rgif)
boxplot(charity$rgif, main = "rgif Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/rgif_box.png')
dev.off()
hist(charity$rgif, main = "rgif Histogram", breaks = 50)
dev.copy(png,'./EDA/rgif_hist.png')
dev.off()
```

#### tdon  
Number of months since last donation  
```{r}
fivenum(charity$tdon)
boxplot(charity$tdon, main = "tdon Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/tdon_box.png')
dev.off()
hist(charity$tdon, main = "tdon Histogram")
dev.copy(png,'./EDA/tdon_hist.png')
dev.off()
```

#### tlag  
Number of months between first and second gift  
```{r}
fivenum(charity$tlag)
boxplot(charity$tlag, main = "tlag Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/tlag_box.png')
dev.off()
hist(charity$tlag, main = "tlag Histogram")
dev.copy(png,'./EDA/tlag_hist.png')
dev.off()
```

#### agif  
Average dollar amount of gifts to date  
```{r}
fivenum(charity$agif)
boxplot(charity$agif, main = "agif Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/agif_box.png')
dev.off()
hist(charity$agif, main = "agif Histogram")
dev.copy(png,'./EDA/agif_hist.png')
dev.off()
```

#### DONR    
Classification Response Variable (0 = Non-Donor, 1 = Donor)
```{r}
counts6 <- table(charity$donr)
counts6
barplot(counts6, main = "donr Barplot")
dev.copy(png,'./EDA/donr_bar.png')
dev.off()
```

#### DAMT    
Prediction Response Variable (Donation Amount in $)   
```{r}
fivenum(charity$damt)
boxplot(charity$damt, main = "damt Boxplot", horizontal = TRUE)
dev.copy(png,'./EDA/damt_box.png')
dev.off()
hist(charity$damt, main = "damt Histogram")
dev.copy(png,'./EDA/damt_hist.png')
dev.off()
```
