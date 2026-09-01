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
	)
	|> mutate(new_cases = rollmean(new_cases,k=7,fill=NA,align="right",na.rm=TRUE)
	)
	|> ungroup()
	|> group_by(date)
	|> ungroup()
)

print(dat, n=Inf)

dat2 <- (dat
	|> mutate(NULL
		, province2 = ifelse(province == "Ituri","Ituri","Other")
		, province2 = ifelse(province == "Nord-Kivu", "Nord-Kivu",province2)
		)
	|> group_by(date,province)
	|> mutate(new_cases2 = sum(new_cases))
)

gg <- (ggplot(dat, aes(x=date,y=new_cases,fill=province))
#	+ geom_area(position="fill")
	+ geom_area(position="stack")
)
print(gg)

gg2 <- (ggplot(dat2, aes(x=date,y=new_cases2,fill=province))
	+ geom_area(position="stack")
#	+ xlim(c(as.Date("2026-08-01"),NA))
)

print(gg2)
gg2 <- (ggplot(dat2, aes(x=date,y=new_cases2,fill=province))
	+ geom_area(position="fill")
#	+ xlim(c(as.Date("2026-08-01"),NA))
)

print(gg2)

gg2 <- (ggplot(dat2, aes(x=date,y=new_cases2,fill=province2))
	+ geom_area(position="stack")
#	+ xlim(c(as.Date("2026-08-01"),NA))
)

print(gg2)
gg2 <- (ggplot(dat2, aes(x=date,y=new_cases2,fill=province2))
	+ geom_area(position="fill")
#	+ xlim(c(as.Date("2026-08-01"),NA))
)

print(gg2)
