
library(tidyverse);theme_set(theme_bw())

library(shellpipes)

loadEnvironments()

dd <- rdsRead()

start <- "2022-05-01"
end <- Sys.Date() + 1

gg <- (ggplot(dd)
	+ geom_point(aes(x=datefill,y=Inc),color="blue")
	+ geom_point(aes(x=datefill,y=predInc),color="red")
	+ geom_line(aes(x=datefill,y=med),color="black")
	+ geom_ribbon(aes(x=datefill,ymin=lwr,ymax=upr),alpha=0.2)
#	+ coord_cartesian(xlim=as.Date(c(start,end))
#		, ylim=c(0,200)
#	)	
	+ ylab("Daily Reports")
	+ xlab("Date")
)

print(gg)


