SHEL := /bin/sh
PDFLATEX := pdflatex
FONTFORGE := fontforge
AFMTOTFM := afm2tfm
RM := rm -rf
TAR := tar
ZIP := zip
INSTALL := install
INSTALLDIR := $(INSTALL) -d
INSTALLDATA := $(INSTALL) -m 644

ifneq (,$(findstring install,$(MAKECMDGOALS)))
TEXMFDIR := $(shell kpsewhich -expand-var='$$TEXMFHOME')
endif

pkg := ccicons
files := $(pkg).ins $(pkg).dtx $(pkg)-u.enc $(pkg).map $(pkg).pdf $(pkg).sfd
genfiles := $(pkg).pfb $(pkg).afm $(pkg).tfm
tempfiles := $(pkg).aux $(pkg).log $(pkg).idx $(pkg).ilg $(pkg).ind $(pkg).glo $(pkg).gls $(pkg).out $(pkg).hd

# default rule

.PHONY: all
all: type1 metrics latex

# rules for building the Postscript font

.PHONY: type1
type1: $(pkg).pfb

$(pkg).pfb $(pkg).afm: $(pkg).sfd
	$(FONTFORGE) -lang=ff -c 'Open("$<"); Generate("$(pkg).pfb"); Quit(0)'

# rules for building the TeX font metrics

.PHONY: metrics
metrics: $(pkg).tfm

$(pkg).tfm: $(pkg).afm
	$(AFMTOTFM) $(pkg).afm

# rules for building the LaTeX package

.PHONY: latex
latex: $(pkg).sty

$(pkg).sty: $(pkg).ins $(pkg).dtx
	$(PDFLATEX) $(pkg).ins

# rules for building the PDF documentation

.PHONY: doc
doc: $(pkg).pdf

$(pkg).pdf: $(pkg).dtx
	$(PDFLATEX) $(pkg).dtx
	while grep -s 'Rerun to get' $(pkg).log; do \
	  $(PDFLATEX) $(pkg).dtx; \
	done

# rules for building a TDS zip file

.PHONY: tds
tds: $(pkg).tds.zip

$(pkg).tds.zip: $(files) $(genfiles) $(pkg).sty $(pkg).pdf
	$(MAKE) install TEXMFDIR:=tds.tmp
	(cd tds.tmp && $(ZIP) -r - *) > $@
	$(RM) tds.tmp

# rules for building a tarball for CTAN

.PHONY: dist
dist: $(pkg).tar.gz

$(pkg).tar.gz: $(pkg).tds.zip $(files) $(genfiles) $(pkg).pdf README.ctan
	$(TAR) -cz -s '/README\.ctan/README/' $^ > $@

# rules for (un)installing everything

.PHONY: install
install: all
	$(INSTALLDIR) $(TEXMFDIR)/fonts/enc/dvips/$(pkg)
	$(INSTALLDATA) $(pkg)-u.enc $(TEXMFDIR)/fonts/enc/dvips/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/map/dvips/$(pkg)
	$(INSTALLDATA) $(pkg).map $(TEXMFDIR)/fonts/map/dvips/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/tfm/public/$(pkg)
	$(INSTALLDATA) $(pkg).tfm $(TEXMFDIR)/fonts/tfm/public/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/type1/public/$(pkg)
	$(INSTALLDATA) $(pkg).pfb $(TEXMFDIR)/fonts/type1/public/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDATA) $(pkg).sty $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/doc/latex/$(pkg)
	$(INSTALLDATA) $(pkg).pdf $(TEXMFDIR)/doc/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/source/latex/$(pkg)
	$(INSTALLDATA) $(pkg).ins $(pkg).dtx $(TEXMFDIR)/source/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/source/fonts/$(pkg)
	$(INSTALLDATA) $(pkg).sfd $(TEXMFDIR)/source/fonts/$(pkg)

.PHONY: uninstall
uninstall:
	$(RM) $(TEXMFDIR)/fonts/enc/dvips/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/map/dvips/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/tfm/public/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/type1/public/$(pkg)
	$(RM) $(TEXMFDIR)/tex/latex/$(pkg)
	$(RM) $(TEXMFDIR)/doc/latex/$(pkg)
	$(RM) $(TEXMFDIR)/source/latex/$(pkg)
	$(RM) $(TEXMFDIR)/source/fonts/$(pkg)

# rule for cleaning the source tree

.PHONY: clean
clean:
	$(RM) $(genfiles) $(pkg).sty $(pkg).tds.zip $(pkg).tar.gz
	$(RM) $(tempfiles)

# delete files on error

.DELETE_ON_ERROR:
