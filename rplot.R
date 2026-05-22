library(dplyr)
library(bbmle)
library(ggplot2);theme_set(theme_bw())
library(broom.mixed)
library(shellpipes)

expfit <- readRDS("expfit.rds")
bintr_fit <- readRDS("fit.rds")
bintr_death_fit <- readRDS("fit_death.rds")

dat <- data.frame(r = c(coef(expfit$casemod)[2]
		, coef(expfit$deathmod)[2]
		, as.numeric(tidy(bintr_fit)[3,2])
		, as.numeric(tidy(bintr_death_fit)[3,2])
		)
	, sde = c(sqrt(vcov(expfit$casemod)[2,2])
		, sqrt(vcov(expfit$deathmod)[2,2])
		, as.numeric(tidy(bintr_fit)[3,3])
		, as.numeric(tidy(bintr_death_fit)[3,3])
		)
	, type = c("exp_cases","exp_death","bintr_cases","bintr_death")
)

print(dat)


gg <- (ggplot(dat, aes(type,y=r))
	+ geom_pointrange(aes(ymin=r-1.96*sde, ymax=r+1.96*sde))
	+ geom_point()
	+ coord_flip()
	+ ylab("Growth Rate (per day)")
)

print(gg)

rdsSave(dat)
