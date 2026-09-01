library(tidyverse);theme_set(theme_bw())
library(zoo)
library(shellpipes)
library(cowplot)
startGraphics(width=8, height=6)

dat <- (csvRead()
	|> arrange(province,date)
	|> ungroup()
	|> group_by(province)
	|> mutate(NULL
		, province = as.factor(province)
		, new_cases = diff(c(0,cases))
		, new_deaths = diff(c(0,deaths))
	)
	|> mutate(NULL
#		, new_cases = rollmean(new_cases,k=7,fill=NA,align="right",na.rm=TRUE)
#		, new_deaths = rollmean(new_deaths,k=7,fill=NA,align="right",na.rm=TRUE)
	)
	|> ungroup()
	|> group_by(date)
	|> ungroup()
	|> filter(province != "Sud-Kivu")
)

print(dat, n=Inf)

gg <- (ggplot(dat, aes(x=date,y=new_cases,fill=province))
#	+ geom_area(position="fill")
	+ geom_area(position="stack")
	+ scale_fill_manual(values=c("black","red","blue","orange","purple","green"))
)
print(gg)

gg2 <- (ggplot(dat, aes(x=date,y=new_cases,fill=province))
	+ geom_area(position="fill")
	+ scale_fill_manual(values=c("black","red","blue","orange","purple","green"))
)

print(gg2)

ggd <- (ggplot(dat, aes(x=date,y=new_deaths,fill=province))
#	+ geom_area(position="fill")
	+ geom_area(position="stack")
	+ scale_fill_manual(values=c("black","red","blue","orange","purple","green"))
)
print(ggd)

ggd2 <- (ggplot(dat, aes(x=date,y=new_deaths,fill=province))
	+ geom_area(position="fill")
	+ scale_fill_manual(values=c("black","red","blue","orange","purple","green"))
)

print(ggd2)

comboplot <- plot_grid(gg,ggd,gg2,ggd2,nrow=2)

print(comboplot)
