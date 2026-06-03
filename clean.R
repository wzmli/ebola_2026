library(readr)
library(dplyr)
library(tidyr)
library(ggplot2);theme_set(theme_bw())
library(shellpipes)
startGraphics(width=6,height=5)

dat <- rdsRead()

incdat <- (dat
	|> mutate(Inc = diff(c(0,suspect_cases))
		, newDeath = diff(c(0,suspect_death))
		, cases = diff(c(0,confirmed_cases))
	)
)

longdat <- (incdat
	|> pivot_longer(!date, names_to ="type", values_to="value")
	|> filter(date > as.Date("2026-05-01"))
)

print(longdat)

print(gg <- ggplot(longdat, aes(date,value))
	+ geom_point()
	+ facet_wrap(~type,scale="free")
)

print(gg %+% filter(longdat,type %in% c("suspect_cases","confirmed_cases","suspect_death","confirmed_death"))
	+ ylab("Count")
	+ geom_vline(aes(xintercept=as.Date("2026-05-28")),linetype="dotted")
)

rdsSave(incdat)
