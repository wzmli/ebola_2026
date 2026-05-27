library(tidyverse);theme_set(theme_bw())
library(shellpipes)
library(cowplot)
startGraphics(width=6,height=5)

naive <- rdsRead("tidyfit.rds") |> mutate(start_date = as.Date("2026-04-25"))
phylo1 <- rdsRead("phyloplot.rds") |> mutate(start_date = as.Date("2026-03-25"))
phylo2 <- rdsRead("phyloplot2.rds") |> mutate(start_date = as.Date("2026-04-11"))

dat <- rdsRead("clean.rds")
print(dat)

preds <- (bind_rows(naive, phylo1, phylo2)
	|> filter(date>=start_date)
	|> mutate(start_date = factor(start_date))
)

print(preds)

csvSave(preds)

gg <- (ggplot(preds,aes(date,pred))
	+ geom_line(aes(group=interaction(seed,start_date),color=start_date),alpha=0.1)
	+ geom_point(data=filter(dat,date>as.Date("2026-04-25")),aes(x=date,y=Inc))
	+ facet_wrap(~start_date,nrow=3)
	+ theme(legend.position="none")
	+ ylab("Daily Suspect Cases")
	+ xlim(as.Date(c(NA,as.Date("2026-07-01"))))
)


gg2 <- (ggplot(preds,aes(date,cumInc))
	+ geom_line(aes(group=interaction(seed,start_date),color=start_date),alpha=0.1)
	+ geom_point(data=filter(dat,date>as.Date("2026-04-25")),aes(x=date,y=suspect_cases))
	+ facet_wrap(~start_date,nrow=3)
	+ theme(legend.position="none")
	+ ylab("Cumulative Suspect Cases")
	+ xlim(as.Date(c(NA,as.Date("2026-07-01"))))
)

comboplot <- (plot_grid(gg,gg2,nrow=1))

print(comboplot)
