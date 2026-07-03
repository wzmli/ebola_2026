library(tidyverse);theme_set(theme_bw())
library(cowplot)
library(shellpipes)
startGraphics(width=6,height=4)

dat <- csvRead() |> filter(date > as.Date("2026-05-01"))

print(dat |> select(date,doubling_s,doubling_c), n=Inf)

gg1 <- (ggplot(dat,aes(x=date))
	+ geom_point(aes(y=suspect_cases),color="red")
	+ geom_point(aes(y=confirmed_cases),color="blue")
	+ ylab("Cumulative cases")
	+ ggtitle("Cumulative cases")
)

print(gg1)

gg2 <- (ggplot(dat,aes(x=date))
	+ geom_line(aes(y=doubling_s),color="red")
	+ geom_line(aes(y=doubling_c),color="blue")
	+ ylab("Doubling time")
	+ ggtitle("Doubling time")
)

print(gg2)

print(plot_grid(gg1,gg2,rows=1))
