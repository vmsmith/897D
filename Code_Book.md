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
