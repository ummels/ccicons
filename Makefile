SHELL := /bin/sh
FONTFORGE := fontforge
RM := rm -rf

files := ccicons.sfd OFL.txt FONTLOG.txt
genfiles := ccicons.pfb ccicons.afm ccicons.enc ccicons.tfm ccicons.otf ccicons.map

# default rule

.PHONY: all
all: fonts

.PHONY: fonts
fonts: type1 opentype metrics

# rules for building the Postscript font

.PHONY: type1
type1: ccicons.pfb

.PHONY: metrics
metrics: ccicons.tfm ccicons.map

ccicons.pfb ccicons.afm ccicons.tfm ccicons.enc: ccicons.sfd
	$(FONTFORGE) -lang=ff -c 'Open("$<"); Generate("ccicons.pfb", "", 0x10001); Quit(0)'

# rules for building the OpenType font

.PHONY: opentype
opentype: ccicons.otf

ccicons.otf: ccicons.sfd
	$(FONTFORGE) -lang=ff -c 'Open("$<"); Generate("ccicons.otf"); Quit(0)'

# rules for building the TeX font metrics and the mapfile

ccicons.map:
	echo "ccicons CCIcons <ccicons.pfb" > ccicons.map

# rule for cleaning the source tree

.PHONY: clean
clean:
	$(RM) $(genfiles)

# delete files on error

.DELETE_ON_ERROR:
