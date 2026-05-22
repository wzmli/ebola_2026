library(tidyverse)
library(bbmle)
library(shellpipes)
loadEnvironments()

init_lK <- 10

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

print(fitdf,n=Inf)

m <- mle2(fitdf$newDeath ~ dnbinom(mu=flexSim(lK, li0,rsim,time)$intSim, size=ss)
	, start = list(lK=log(init_lK),li0=1,rsim=0.1,ss=1)
	, data = fitdf
)

print(m)

print(summary(m))

