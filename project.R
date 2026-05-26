library(tidyverse);theme_set(theme_bw())
library(shellpipes)

params <- rdsRead("rcombo_plot.rds")
dat <- rdsRead("phylo_dates.rds")

print(params)
print(dat)

bintr <- (params
	|> filter(type == "bintr_cases")
)

data.frame(

