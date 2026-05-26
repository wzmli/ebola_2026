## This is ebola_2026

current: target
-include target.mk
Ignore = target.mk

vim_session:
	bash -cl "vmt"

######################################################################

### Makestuff

Sources += Makefile $(wildcard *.R) data.csv

Ignore += makestuff
msrepo = https://github.com/dushoff

######################################################################

alldirs += bintr
bintr/%: | bintr ;
Ignore  += $(alldirs)

bintr: 
	git clone https://github.com/wzmli/bintr

######################################################################

## data2.csv

read.Rout: read.R data.csv
	$(pipeR)

clean.Rout: clean.R read.rds
	$(pipeR)

flexSim.Rout: bintr/flexSim.R
	$(pipeR)

expfit.Rout: expfit.R clean.rds
	$(pipeR)

fit.Rout: fit.R clean.rds flexSim.rda
	$(pipeR)

fit_death.Rout: fit_death.R clean.rds flexSim.rda
	$(pipeR)

tidyfit.Rout: tidyfit.R fit.rds flexSim.rda
	$(pipeR)

fitplot.Rout: fitplot.R tidyfit.rds
	$(pipeR)

rplot.Rout: rplot.R expfit.rds fit.rds fit_death.rds
	$(pipeR)

cumplot.Rout: cumplot.R rplot.rds clean.rds
	$(pipeR)

phylo_dates.Rout: phylo_dates.R read.rds 
	$(pipeR)

phylo_dates2.Rout: phylo_dates2.R read.rds 
	$(pipeR)

phylo_fit.Rout: fit.R phylo_dates.rds flexSim.rda
	$(pipeR)

phylo_fit2.Rout: fit.R phylo_dates2.rds flexSim.rda
	$(pipeR)

rcombo_plot.Rout: rcombo_plot.R phylo_fit.rds phylo_fit2.rds rplot.rds
	$(pipeR)

project.Rout: project.R rcombo_plot.rds phylo_dates.rds
	$(pipeR)

######################################################################

## ln -s ../makestuff . ## Do this first if you want a linked makestuff
Makefile: makestuff/00.stamp
makestuff/%.stamp: | makestuff
	- $(RM) makestuff/*.stamp
	cd makestuff && $(MAKE) pull
	touch $@
makestuff:
	git clone --depth 1 $(msrepo)/makestuff

-include makestuff/os.mk

-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
