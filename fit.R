library(tidyverse)
library(bbmle)
library(shellpipes)
loadEnvironments()

init_lK <- 10

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

print(fitdf,n=Inf)

m <- mle2(fitdf$Inc ~ dnbinom(mu=flexSim(lK, li0,rsim,time)$intSim, size=ss)
	, start = list(lK=log(init_lK),li0=1,rsim=0.2,ss=1)
	, data = fitdf
)

print(m)

print(summary(m))

## Do I do the same for death?
