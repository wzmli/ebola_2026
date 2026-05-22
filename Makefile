## This is ebola_2026

## This section is for Dushoff-style vim-setup and vim targeting
## You can delete it if you don't want it
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

bintr_repo: 
	git clone https://github.com/wzmli/bintr.git

read.Rout: read.R data.csv
	$(pipeR)

clean.Rout: clean.R read.rds
	$(pipeR)

flexSim.Rout: bintr/flexSim.R
	$(pipeR)

fit.Rout: fit.R clean.rds flexSim.rda
	$(pipeR)

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
