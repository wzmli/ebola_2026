library(readr)
library(shellpipes)

dat <- csvRead()

print(dat)

rdsSave(dat)
