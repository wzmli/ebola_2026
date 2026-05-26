library(tidyverse)
library(bbmle)
library(shellpipes)
loadEnvironments()

init_lK <- 6.5

peak <- (rdsRead()
	|> select(date,Inc)
	|> filter(date > as.Date("2026-05-15"))
	|> filter(Inc == max(Inc))
)


# start_date <- as.Date("2026-05-14")

fitdf <- (rdsRead()
	|> filter(date <= peak[["date"]])
	|> rename(time = date)
	|> mutate(NULL
		, time = as.numeric(time-min(time))
		, Inc = round(Inc) ## Do I really need this?!?
		, Inc = ifelse(Inc == 0,1,Inc)
	)
)

print(fitdf)

m <- mle2(fitdf$Inc ~ dnbinom(mu=flexSim(lK, li0,rsim,time)$intSim, size=ss)
	, start = list(lK=log(init_lK),li0=1,rsim=0.1,ss=1)
	, data = fitdf
)

print(m)

print(summary(m))

rdsSave(m)

