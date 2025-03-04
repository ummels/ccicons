SHELL := /bin/sh
PDFLATEX := pdflatex -interaction nonstopmode -halt-on-error
LATEX := latex -interaction nonstopmode -halt-on-error
LUALATEX := lualatex -interaction nonstopmode -halt-on-error
DVIPS := dvips
FONTFORGE := fontforge
AFMTOTFM := afm2tfm
RM := rm -rf
TAR := gtar -c -z --owner=root --group=root --mode='a+r'
ZIP := zip
INSTALL := install
INSTALLDIR := $(INSTALL) -d
INSTALLDATA := $(INSTALL) -m 644

ifneq (,$(findstring install,$(MAKECMDGOALS)))
TEXMFDIR := $(shell kpsewhich -expand-var='$$TEXMFHOME')
endif

pkg := ccicons
files := $(pkg).ins $(pkg).dtx $(pkg)-u.enc $(pkg).pdf $(pkg).sfd OFL.txt FONTLOG.txt
genfiles := $(pkg).pfb $(pkg).afm $(pkg).tfm $(pkg).otf $(pkg).map
tempfiles := $(pkg).aux $(pkg).log $(pkg).idx $(pkg).ilg $(pkg).ind $(pkg).glo $(pkg).gls $(pkg).out $(pkg).hd test-$(pkg).aux test-$(pkg).log test-$(pkg)-luatex.aux test-$(pkg)-luatex.log
testfiles := test-$(pkg).pdf test-$(pkg).ps test-$(pkg).dvi test-$(pkg)-luatex.pdf

# default rule

.PHONY: all
all: type1 opentype metrics mapfile latex

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
metrics: $(pkg).tfm

.PHONY: mapfile
mapfile: $(pkg).map

$(pkg).tfm $(pkg).map: $(pkg).afm
	res=$$($(AFMTOTFM) $(pkg).afm) && echo "$$res <$(pkg).pfb" > $(pkg).map

# rules for building the LaTeX package

.PHONY: latex
latex: $(pkg).sty

$(pkg).sty test-$(pkg).tex: $(pkg).ins $(pkg).dtx
	$(LATEX) $(pkg).ins

# rules for running the tests

.PHONY: test
test: all test-$(pkg).tex
	@echo "Testing pdflatex..."
	$(PDFLATEX) -jobname test-$(pkg) "\pdfmapfile{$(pkg).map}\input{test-$(pkg)}"
	@echo ""
	@echo "Testing lualatex..."
	$(LUALATEX) -jobname test-$(pkg)-luatex "\directlua{pdf.mapfile('$(pkg).map')}\input{test-$(pkg)}"

# rules for building the PDF documentation

.PHONY: doc
doc: $(pkg).pdf

$(pkg).pdf: $(pkg).dtx $(pkg).pfb $(pkg).tfm $(pkg).sty $(pkg).map
	$(PDFLATEX) "\pdfmapfile{+$(pkg).map}\input{$<}"
	while grep -s 'Rerun to get' $(pkg).log; do \
	  $(PDFLATEX) "\pdfmapfile{+$(pkg).map}\input{$<}"; \
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

$(pkg).tar.gz: $(pkg).tds.zip $(files) $(genfiles) $(pkg).pdf README.ctan.md
	$(TAR) --transform 's,^,$(pkg)/,g' --transform 's,README\.ctan\.md,README.md,' --transform 's,$(pkg)/$(pkg).tds.zip,$(pkg).tds.zip,' $^ > $@

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
	$(INSTALLDIR) $(TEXMFDIR)/fonts/opentype/public/$(pkg)
	$(INSTALLDATA) $(pkg).otf $(TEXMFDIR)/fonts/opentype/public/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDATA) $(pkg).sty $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/doc/fonts/$(pkg)
	$(INSTALLDATA) FONTLOG.txt OFL.txt $(TEXMFDIR)/doc/fonts/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/doc/latex/$(pkg)
	$(INSTALLDATA) README.ctan.md $(TEXMFDIR)/doc/latex/$(pkg)/README.md
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
	$(RM) $(TEXMFDIR)/fonts/opentype/public/$(pkg)
	$(RM) $(TEXMFDIR)/tex/latex/$(pkg)
	$(RM) $(TEXMFDIR)/doc/fonts/$(pkg)
	$(RM) $(TEXMFDIR)/doc/latex/$(pkg)
	$(RM) $(TEXMFDIR)/source/latex/$(pkg)
	$(RM) $(TEXMFDIR)/source/fonts/$(pkg)

# rule for cleaning the source tree

.PHONY: clean
clean:
	$(RM) $(genfiles) $(pkg).sty test-$(pkg).tex $(pkg).tds.zip $(pkg).tar.gz
	$(RM) $(tempfiles) $(testfiles)

# delete files on error

.DELETE_ON_ERROR:
