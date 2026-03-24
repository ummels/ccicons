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

# rules for building the Postscript font, the TeX font metrics and related files

.PHONY: type1
type1: ccicons.pfb ccicons.enc ccicons.map

.PHONY: metrics
metrics: ccicons.tfm

ccicons.pfb ccicons.afm ccicons.tfm ccicons.enc: ccicons.sfd
	$(FONTFORGE) -lang=ff -c 'Open("$<"); Generate("ccicons.pfb", "", 0x10001); Quit(0)'

ccicons.map:
	echo "ccicons CCIcons <ccicons.pfb" > ccicons.map

# rules for building the OpenType font

.PHONY: opentype
opentype: ccicons.otf

ccicons.otf: ccicons.sfd
	$(FONTFORGE) -lang=ff -c 'Open("$<"); Generate("ccicons.otf"); Quit(0)'

# rule for cleaning the source tree

.PHONY: clean
clean:
	$(RM) $(genfiles)

# delete files on error

.DELETE_ON_ERROR:
