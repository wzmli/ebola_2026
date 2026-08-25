library(tidyverse);theme_set(theme_bw())
library(zoo)
library(shellpipes)

dat <- (csvRead()
	|> arrange(province,date)
	|> ungroup()
	|> group_by(province)
	|> mutate(NULL
		, province = as.factor(province)
		, new_cases = diff(c(0,cases))
		, new_deaths = diff(c(0,deaths))
		, avgcases = round(rollmean(new_cases,k=7,fill=NA,align="right",na.rm=TRUE))
		, avgdeath = round(rollmean(new_deaths,k=7,fill=NA,align="right",na.rm=TRUE))
	)
)

gg <- (ggplot(filter(dat,new_cases>0, province %in% c("Ituri","Nord-Kivu","Haut-Uele")), aes(date))
	+ geom_point(aes(y=new_cases,color=province))
	+ geom_line(aes(y=avgcases,color=province))
#	+ geom_smooth()
	+ facet_wrap(~province, scale="free", nrow=3)
)

print(dat,n=Inf)

print(gg)

rdsSave(dat)
