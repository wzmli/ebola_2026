library(dplyr)
library(tidyr)
library(shellpipes)

dat <- rdsRead()

phylodate <- data.frame(
	date = as.Date(c("2026-04-11"))
	, suspect_cases = c(1)
	, suspect_death = c(1)
)

newdat <- bind_rows(phylodate, dat)

print(newdat)

incdat <- (newdat
	|> mutate(Inc = diff(c(0,suspect_cases))
		, newDeath = diff(c(0,suspect_death))
	)
)

print(incdat)

rdsSave(incdat)
