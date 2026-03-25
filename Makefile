SHELL := /bin/sh
FONTFORGE := fontforge
RM := rm -rf
genfiles := ccicons.pfb ccicons.afm ccicons.enc ccicons.tfm ccicons.otf ccicons.map

# Rules

.PHONY: all
all: fonts

.PHONY: fonts
fonts: $(genfiles)

.PHONY: clean
clean:
	$(RM) $(genfiles)

ccicons.pfb ccicons.afm ccicons.tfm ccicons.enc: ccicons.sfd
	$(FONTFORGE) -lang=ff -c 'Open("$<"); Generate("ccicons.pfb", "", 0x10001); Quit(0)'

ccicons.map:
	echo "ccicons CCIcons <ccicons.pfb" > ccicons.map

ccicons.otf: ccicons.sfd
	$(FONTFORGE) -lang=ff -c 'Open("$<"); Generate("ccicons.otf"); Quit(0)'

# delete files on error

.DELETE_ON_ERROR:
