library(tidyverse);theme_set(theme_bw())
library(zoo)
library(shellpipes)
startGraphics(width=5, height=3)

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
		, avgcases2 = round(rollmean(avgcases,k=7,fill=NA,align="right",na.rm=TRUE))
		, avgdeath2 = round(rollmean(avgdeath,k=7,fill=NA,align="right",na.rm=TRUE))
		, naiveRt_cases = avgcases/avgcases2
		, naiveRt2 = rollmean(naiveRt_cases,k=7,fill=NA,align="right",na.rm=TRUE)
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

ggRt <- (ggplot(filter(dat,new_cases>0, province %in% c("Ituri","Nord-Kivu","Haut-Uele")), aes(date))
#	+ geom_point(aes(y=new_cases,color=province))
	+ geom_smooth(aes(y=naiveRt_cases,color=province,fill=province))
#	+ geom_line(aes(y=naiveRt2,color=province,fill=province))
	+ geom_hline(aes(yintercept = 1))
#	+ geom_smooth()
	+ scale_color_manual(values=c("red","blue","green"))
	+ scale_fill_manual(values=c("red","blue","green"))
#	+ facet_wrap(~province, scale="free", nrow=3)
)

print(ggRt)

rdsSave(dat)
