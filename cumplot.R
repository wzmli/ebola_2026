library(ggplot2);theme_set(theme_bw())
library(dplyr)
library(shellpipes)
library(zoo)

params <- rdsRead("rplot")
dat <- (rdsRead("clean")
	
)

print(params)
print(dat)

mindate <- min(dat$date)
maxdate <- max(dat$date)

casedate <- as.Date("2026-05-19")
deathdate <- as.Date("2026-05-16")

newdat <- (data.frame(date = as.Date(mindate:maxdate))
	|> mutate(time = as.numeric(date - min(date))
	)
)

print(newdat)

predfun <- function(x){
	dd <- (newdat
		|> mutate(pred = exp(params[x,"r"]*time)
			, predmin = exp((params[x,"r"]-1.96*params[x,"sde"])*time)
			, predmax = exp((params[x,"r"]+1.96*params[x,"sde"])*time)
			, cumpred = cumsum(pred)
			, cumpredmin = cumsum(predmin)
			, cumpredmax = cumsum(predmax)
			, type = params[x,"type"]
			, type2 = ifelse(grepl("death",type),"death","cases")
			, type3 = ifelse(grepl("exp",type),"exp","bintr")
		)
	)
	return(dd)
}

predlist <- lapply(1:nrow(params),predfun)

preddf <- (bind_rows(predlist)
		|> rowwise()
		|> mutate(NULL
			, pred = ifelse(((type2=="death")&(date>deathdate)),NA,pred)
			, pred = ifelse(((type2=="cases")&(date>casedate)),NA,pred)
			, cumpred = ifelse(((type2=="death")&(date>deathdate)),NA,cumpred)
			, cumpred = ifelse(((type2=="cases")&(date>casedate)),NA,cumpred)
		)
)

incdat <- data.frame(date = c(dat$date,dat$date)
	, type2 = rep(c("cases","death"),each=length(dat$date))
	, value = c(dat$Inc,dat$newDeath)
)

cumdat <- data.frame(date = c(dat$date,dat$date)
	, type2 = rep(c("cases","death"),each=length(dat$date))
	, value = c(dat$suspect_cases,dat$suspect_death)
)


(ggplot(preddf,aes(x=date,y=pred))
	+ geom_line()
#	+ geom_ribbon(aes(ymin=predmin,ymax=predmax),alpha=0.2)
	+ facet_grid(type2~type3,scale="free")
	+ geom_point(data=incdat,aes(x=date,y=value))
)

#(ggplot(preddf,aes(x=date,y=cumpred))
#	+ geom_line()
#	+ facet_grid(type2~type3,scale="free")
#	+ geom_point(data=cumdat,aes(x=date,y=value))
#)

