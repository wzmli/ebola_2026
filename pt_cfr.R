library(tidyverse);theme_set(theme_bw())
library(shellpipes)

dat <- (rdsRead()
	|> mutate(NULL
		, province = as.factor(province)
		, cfr = deaths/cases
	)
	|> group_by(province)
	|> mutate(total_cases = max(cases,na.rm=TRUE))
)

print(dat)


gg <- (ggplot(dat,aes(date,cfr,color=province))
	+ geom_point(aes(size=total_cases))
	+ scale_size_area()
	+ geom_line()
#	+ facet_wrap(~province)
)

print(gg)

