library(tidyverse);theme_set(theme_bw())
library(zoo)
library(cowplot)
library(shellpipes)
startGraphics(width=8,height=6)

dat <- rdsRead()

phydat <- data.frame(date = as.Date("2026-06-23")
	, med = 11.5
	, lwr = 7
	, upr = 17
)

dtdat <- function(x){

fitdat <- (dat
	|> filter(date > as.Date("2026-05-15"))
#	|> filter(date < as.Date("2026-07-11"))
	|> filter(province == x)
	|> transmute(time = as.numeric(date - min(date))
		, cinc = cases
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
		, dt.lwr = time - difftime - 1.96*difftime.se
		, dt.upr = time - difftime + 1.96*difftime.se
		, province = x
	)
)

}


dflist <- bind_rows(lapply(c("Ituri","Nord-Kivu","Haut-Uele"),dtdat))

print(dflist)

ggdt <- (ggplot(dflist, aes(date,group=province))
	+ geom_line(aes(y=dt,color=province))
	+ geom_ribbon(aes(ymin=dt.lwr,ymax=dt.upr,fill=province),alpha=0.2)
#	+ ylim(c(0,35))
	+ facet_wrap(~province,ncol=3, scale="free_y")
#	+ geom_pointrange(data=phydat,aes(x=date,y=med,ymin=lwr,ymax=upr))
	+ xlim(c(as.Date("2026-05-01"),as.Date("2026-08-27")))
	+ ylab("Doubling Time (days)")
	+ xlab("Date")
	+ theme(legend.position="none")
)

print(ggdt)


ggcases <- (ggplot(filter(dat,new_cases>0, new_cases<150,province %in% c("Ituri","Nord-Kivu","Haut-Uele")), aes(date))
	+ geom_point(aes(y=new_cases,color=province))
	+ geom_line(aes(y=avgcases,color=province))
#	+ geom_smooth()
	+ xlim(c(as.Date("2026-05-01"),as.Date("2026-08-27")))
#	+ ylim(c(0,150))
	+ ylab("New Cases")
	+ xlab("Date")
	+ theme(legend.position="none")
	+ facet_wrap(~province, ncol=3, scale="free_y")
	+ theme(legend.position="none")
)

print(ggcases)

ggcombo <- (plot_grid(ggcases,ggdt,nrow=2))

print(ggcombo)
