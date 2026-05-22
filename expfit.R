library(shellpipes)
library(dplyr)

dat <- (rdsRead()
	|> mutate(time = as.numeric(date - min(date)))
)

print(dat)

casefit <- (lm(log(suspect_cases)~time,data=dat))
casefit <- (lm(log(Inc)~time,data=dat))

print(summary(casefit))

deathfit <- (lm(log(suspect_death)~time,data=dat))
deathfit <- (lm(log(newDeath)~time,data=dat))

print(summary(deathfit))

fitlist <- list(casemod = casefit, deathmod = deathfit)

rdsSave(fitlist)
