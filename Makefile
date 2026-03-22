SHELL := /bin/sh
FONTFORGE := fontforge
AFMTOPL := afm2pl
PLTOTFM := pltotf
RM := rm -rf

ifneq (,$(findstring install,$(MAKECMDGOALS)))
TEXMFDIR := $(shell kpsewhich -expand-var='$$TEXMFHOME')
endif

pkg := ccicons
files := $(pkg)-u.enc $(pkg).sfd OFL.txt FONTLOG.txt
genfiles := $(pkg).pfb $(pkg).afm $(pkg).pl $(pkg).tfm $(pkg).otf $(pkg).map

# default rule

.PHONY: all
all: fonts

.PHONY: fonts
fonts: type1 opentype metrics

# rules for building the Postscript font

.PHONY: type1
type1: $(pkg).pfb

$(pkg).pfb $(pkg).afm: $(pkg).sfd
	$(FONTFORGE) -lang=ff -c 'Open("$<"); Generate("$(pkg).pfb"); Quit(0)'

# rules for building the OpenType font

.PHONY: opentype
opentype: $(pkg).otf

$(pkg).otf: $(pkg).sfd
	$(FONTFORGE) -lang=ff -c 'Open("$<"); Generate("$(pkg).otf"); Quit(0)'

# rules for building the TeX font metrics and the mapfile

.PHONY: metrics
metrics: $(pkg).tfm $(pkg).map

$(pkg).pl $(pkg).map: $(pkg).afm
	$(AFMTOPL) $(pkg).afm

$(pkg).tfm: $(pkg).pl
	$(PLTOTFM) $(pkg).pl

# rule for cleaning the source tree

.PHONY: clean
clean:
	$(RM) $(genfiles)

# delete files on error

.DELETE_ON_ERROR:
