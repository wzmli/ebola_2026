library(tidyverse);theme_set(theme_bw())
library(bbmle)

library(shellpipes)
loadEnvironments()
nsim <- 20
end <- 100


obj <- rdsRead("fit")
est <- coef(obj)
cc <- confint(obj,method="quad")

dd <- (rdsRead("clean")
#	|> mutate(date = time + as.Date("2026-04-24"))
)

print(dd)

#zeroDate <- min(dd$date)
# dd$predInc = predict(obj)
	
pp <- (pop_pred_samp(obj,n=nsim,PDify=TRUE)
)

pp[,1] <- pp[,1] + rnorm(n=nsim, mean=0.25, sd=0.5)

newdat <- data.frame(time=-60:end)
tempdat <- newdat
ll <- lapply(1:nrow(pp),function(j){
tempdat$pred <- predict(obj,newparams=pp[j,],newdata=newdat)
tempdat$seed = j
return(tempdat)
}
)


print(ll[[1]])

ddpred <- (bind_rows(ll)
%>% group_by(time)
|> mutate(date = time + min(dd$date))
|> ungroup()
|> group_by(seed)
|> mutate(pred = ifelse(is.na(pred),0,pred)
	, cumInc = cumsum(pred)
	)
#%>% summarise(lwr = quantile(pred,probs=0.025,na.rm=TRUE)
#, med = quantile(pred,probs=0.5,na.rm=TRUE)
#, upr = quantile(pred,probs=0.975,na.rm=TRUE)
#)
#%>% left_join(.,dd)
)



	# ddpred <- (data.frame(time = 0:50)
	# 	%>% left_join(.,dd,by="time")
	# 	%>% mutate(
	# 		, pred = est[3]*exp(time*est[1])
	# 		, lwr = est[3]*exp(time*cc[1,1])
	# 		, upr = est[3]*exp(time*cc[1,2])
	# 		, datefill = min(zeroDate,na.rm=TRUE) + time
	# 		, Country = obj$Country
	# 		, cumpred = cumsum(pred)
	# 	)
	# )

print(ddpred$datefill)
print(ddpred$predInc)

print(ddpred)

gg <- (ggplot(ddpred,aes(x=date, y=pred))
	+ geom_line(aes(group=seed),alpha=0.1)
	+ geom_point(data=dd,aes(date,y=Inc))
)

print(gg)
gg2 <- (ggplot(ddpred,aes(x=date, y=cumInc))
	+ geom_line(aes(group=seed),alpha=0.1)
	+ geom_point(data=dd,aes(date,y=suspect_cases))
)

print(gg2)


rdsSave(ddpred)

			
