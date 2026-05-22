
library(tidyverse)
library(bbmle)

library(shellpipes)
loadEnvironments()
nsim <- 200
end <- 100


obj <- rdsRead()
est <- coef(obj$mod)
cc <- confint(obj$mod,method="quad")
dd <- (obj$dat
	|> mutate(date = time + as.Date("2026-04-24"))
)

print(dd)

zeroDate <- min(dd$date)
dd$predInc = predict(obj$mod)
	
pp <- pop_pred_samp(obj$mod,n=nsim,PDify=TRUE)

#pp <- (pp[pp[,1]>7,])

print(pp)

newdat <- data.frame(time=0:end)
tempdat <- newdat
ll <- lapply(1:nrow(pp),function(j){
tempdat$pred <- predict(obj$mod,newparams=pp[j,],newdata=newdat)
tempdat$seed = j
return(tempdat)
}
)


ddpred <- (bind_rows(ll)
%>% group_by(time)
%>% summarise(lwr = quantile(pred,probs=0.025,na.rm=TRUE)
, med = quantile(pred,probs=0.5,na.rm=TRUE)
, upr = quantile(pred,probs=0.975,na.rm=TRUE)
)
%>% mutate(datefill = min(zeroDate,na.rm=TRUE) + time
, Country = NA
)
%>% left_join(.,dd)
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

rdsSave(ddpred)

			
