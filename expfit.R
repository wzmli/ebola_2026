library(shellpipes)
library(dplyr)

peak <- (rdsRead()
	|> select(date,Inc)
	|> filter(Inc == max(Inc))
)

fitdf <- (rdsRead()
	|> filter(date <= peak[["date"]])
	|> rename(time = date)
	|> mutate(NULL
		, time = as.numeric(time-min(time))
		, Inc = round(Inc)) ## Do I really need this?!?
)

casefit <- (lm(log(Inc)~time,data=fitdf))

print(summary(casefit))

peak <- (rdsRead()
	|> select(date,newDeath)
	|> filter(newDeath == max(newDeath))
)

fitdf <- (rdsRead()
	|> filter(date <= peak[["date"]])
	|> rename(time = date)
	|> mutate(NULL
		, time = as.numeric(time-min(time))
		, newDeath = round(newDeath)) ## Do I really need this?!?
)

deathfit <- (lm(log(newDeath)~time,data=fitdf))

print(summary(deathfit))

fitlist <- list(casemod = casefit, deathmod = deathfit)

rdsSave(fitlist)
