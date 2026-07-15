library(tidyverse);theme_set(theme_bw())
library(zoo)
library(cowplot)
library(shellpipes)
startGraphics(width=3,height=4)

dat <- csvRead() |> filter(date > as.Date("2026-05-01"))

print(dat |> select(date,doubling_s,doubling_c), n=Inf)

fitdat <- (dat
	|> filter(date > as.Date("2026-05-15"))
	|> transmute(time = as.numeric(date - min(date))
		, cinc = confirmed_cases
		, date
	)
)

print(fitdat)

mod <- (loess(time ~ cinc, data=fitdat, span=0.75))

print(summary(mod))

newdat <- (fitdat
	|> transmute(cinc = cinc/2)
)

pp <- predict(mod,newdata=newdat,se=TRUE)

print(pp)

fitdat$difftime <- pp$fit
fitdat$difftime.se <- pp$se.fit

newdat2 <- (fitdat
	|> mutate(dt = time - difftime
		, dt.lwr = time - difftime - 2*difftime.se
		, dt.upr = time - difftime + 2*difftime.se
	)
)

gg <- (ggplot(newdat2, aes(date))
	+ geom_line(aes(y=dt))
	+ geom_ribbon(aes(ymin=dt.lwr,ymax=dt.upr),alpha=0.2)
	+ xlim(c(as.Date("2026-06-01"),as.Date("2026-07-16")))
	+ ylab("Doubling Time (days)")
	+ xlab("Date")
)

print(gg)


