## This is ebola_2026

current: target
-include target.mk
Ignore = target.mk

vim_session:
	bash -cl "vmt"

######################################################################

### Makestuff

Sources += Makefile $(wildcard *.R) data.csv README.md who3.csv

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
## data.csv
## who.csv
## who2.csv
## who3.csv

read.Rout: read.R who3.csv
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

tidyfit.Rout: tidyfit.R fit.rds flexSim.rda clean.rds
	$(pipeR)

fitplot.Rout: fitplot.R tidyfit.rds
	$(pipeR)

rplot.Rout: rplot.R expfit.rds fit.rds fit_death.rds
	$(pipeR)

cumplot.Rout: cumplot.R rplot.rds clean.rds
	$(pipeR)

phylo_clean.Rout: phylo_clean.R read.rds 
	$(pipeR)

phylo_clean2.Rout: phylo_clean2.R read.rds 
	$(pipeR)

phylo_fit.Rout: fit.R phylo_clean.rds flexSim.rda
	$(pipeR)

phyloplot.Rout: tidyfit.R phylo_fit.rds flexSim.rda phylo_clean.rds
	$(pipeR)

phylo_fit2.Rout: fit.R phylo_clean2.rds flexSim.rda
	$(pipeR)

phyloplot2.Rout: tidyfit.R phylo_fit2.rds flexSim.rda phylo_clean2.rds
	$(pipeR)

rcombo_plot.Rout: rcombo_plot.R phylo_fit.rds phylo_fit2.rds rplot.rds
	$(pipeR)

project.Rout: project.R tidyfit.rds phyloplot.rds phyloplot2.rds phylo_clean.rds
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
