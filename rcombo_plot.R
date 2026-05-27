library(tidyverse);theme_set(theme_bw())
library(bbmle)
library(shellpipes)
startGraphics(width=4,height=3)

d1 <- rdsRead("phylo_fit.rds")
d2 <- rdsRead("phylo_fit2.rds")
d3 <- rdsRead("rplot.rds")

newdat <- data.frame(
	r = c(coef(d1)[3], coef(d2)[3])
	, sde = c(sqrt(vcov(d1)[3,3]), sqrt(vcov(d2)[3,3]))
	, type = c("bintr_cases", "bintr_cases")
	, start_date = as.Date(c("2026-03-25","2026-04-11"))
)

combodf <- (d3
	|> mutate(start_date = as.Date("2026-04-24"))
	|> bind_rows(newdat)
)

print(combodf)

gg <- (ggplot(filter(combodf,type == "bintr_cases"), aes(x=start_date,y=r))
	+ geom_point()
	+ geom_pointrange(aes(ymin=r - 1.96*sde, ymax=r + 1.96*sde))
	+ ylab("Growth Rate (per day)")
#	+ geom_hline(aes(yintercept=0.053))
#	+ geom_hline(aes(yintercept=0.085))
#	+ geom_hline(aes(yintercept=0.1),color="red")
#	+ geom_hline(aes(yintercept=0.22),color="red")
	+ geom_rect(xmin = as.Date("2026-03-15")
		,xmax=as.Date("2026-05-01")
		,ymin=0.011
		,ymax=0.127
		, alpha=0.1
		)
	+ geom_rect(xmin = as.Date("2026-03-15")
		,xmax=as.Date("2026-05-01")
		,ymin=0.1
		,ymax=0.22
		, alpha=0.1
		, fill="red"
	)

)

print(gg)

rdsSave(combodf)
