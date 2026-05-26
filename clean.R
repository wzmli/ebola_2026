library(readr)
library(dplyr)
library(tidyr)
library(ggplot2);theme_set(theme_bw())
library(shellpipes)

dat <- rdsRead()

incdat <- (dat
	|> mutate(Inc = diff(c(0,suspect_cases))
		, newDeath = diff(c(0,suspect_death))
		, cases = diff(c(0,confirmed_cases))
	)
)

longdat <- (incdat
	|> pivot_longer(!date, names_to ="type", values_to="value")
)

print(longdat)

print(gg <- ggplot(longdat, aes(date,value))
	+ geom_point()
	+ geom_line()
	+ facet_wrap(~type,scale="free")
)

rdsSave(incdat)
