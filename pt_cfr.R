library(tidyverse);theme_set(theme_bw())
library(shellpipes)

dat <- (rdsRead()
	|> mutate(NULL
		, province = as.factor(province)
		, cfr = deaths/cases
	)
)

gg <- (ggplot(dat,aes(date,cfr,color=province))
	+ geom_point()
	+ geom_line()
)

print(gg)

