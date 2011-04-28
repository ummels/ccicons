LATEX = pdflatex
AFMTOTFM = afm2tfm
INSTALL = install
INSTALLDATA = install -m 644

PKG = ccicons
INSTFILES = $(PKG).pfb $(PKG)-u.enc $(PKG).map README.ctan
SRCFILES = $(PKG).ins $(PKG).dtx
GENFILES = $(PKG).tfm
TEXFILES = $(PKG).sty u$(PKG).fd
TEMPFILES = $(PKG).aux $(PKG).log $(PKG).idx $(PKG).ilg $(PKG).ind $(PKG).glo $(PKG).gls
TEXMFDIR = $(shell kpsewhich -expand-var='$$TEXMFHOME')

.PHONY: all metrics package doc ctan install clean

all: metrics package

metrics: $(PKG).tfm

package: $(TEXFILES)

doc: $(PKG).pdf

ctan: $(PKG).tar.gz

$(PKG).tfm: $(PKG).afm
	$(AFMTOTFM) $(PKG).afm

$(TEXFILES): $(SRCFILES)
	$(LATEX) $(PKG).ins

$(PKG).pdf: $(PKG).dtx
	$(LATEX) $(PKG).dtx
	while grep -s 'Rerun to get' $(PKG).log; do \
	  $(LATEX) $(PKG).dtx; \
	done

$(PKG).tar.gz: all doc $(INSTFILES)
	mkdir -p ctan/$(PKG)
	cp $(SRCFILES) $(INSTFILES) $(GENFILES) ctan/$(PKG)
	mkdir -p ctan/doc/latex/$(PKG)
	mkdir -p ctan/fonts/enc/dvips/$(PKG)
	mkdir -p ctan/fonts/map/dvips/$(PKG)
	mkdir -p ctan/fonts/tfm/public/$(PKG)
	mkdir -p ctan/fonts/type1/public/$(PKG)
	mkdir -p ctan/tex/latex/$(PKG)
	mkdir -p ctan/source/latex/$(PKG)
	cp $(PKG).pdf ctan/doc/latex/$(PKG)
	cp $(PKG)-u.enc ctan/fonts/enc/dvips/$(PKG)
	cp $(PKG).map ctan/fonts/map/dvips/$(PKG)
	cp $(PKG).tfm ctan/fonts/tfm/public/$(PKG)
	cp $(PKG).pfb ctan/fonts/type1/public/$(PKG)
	cp $(TEXFILES) ctan/tex/latex/$(PKG)
	cp $(SRCFILES) ctan/source/latex/$(PKG)
	cd ctan && zip -r $(PKG).tds.zip doc fonts tex source
	cd ctan && rm -rf doc fonts tex source
	(cd ctan && tar -c *) | gzip - > $(PKG).tar.gz
	cd ctan/$(PKG) && mv README.ctan README
	rm -rf ctan

install: all doc $(INSTFILES)
	$(INSTALL) -d $(TEXMFDIR)/tex/fonts/enc/dvips/$(PKG)
	$(INSTALL) $(PKG)-u.enc $(TEXMFDIR)/tex/fonts/enc/dvips/$(PKG)
	$(INSTALL) -d $(TEXMFDIR)/tex/fonts/map/dvips/$(PKG)
	$(INSTALL) $(PKG).map $(TEXMFDIR)/tex/fonts/map/dvips/$(PKG)
	$(INSTALL) -d $(TEXMFDIR)/tex/fonts/tfm/public/$(PKG)
	$(INSTALL) $(PKG).tfm $(TEXMFDIR)/tex/fonts/tfm/public/$(PKG)
	$(INSTALL) -d $(TEXMFDIR)/tex/fonts/type1/public/$(PKG)
	$(INSTALL) $(PKG).pfb $(TEXMFDIR)/tex/fonts/type1/public/$(PKG)
	$(INSTALL) -d $(TEXMFDIR)/tex/latex/$(PKG)
	$(INSTALLDATA) $(TEXFILES) $(TEXMFDIR)/tex/latex/$(PKG)
	$(INSTALL) -d $(TEXMFDIR)/doc/latex/fdsymbol
	$(INSTALLDATA) $(PKG).pdf $(TEXMFDIR)/doc/latex/$(PKG)

clean:
	$(RM) $(TEMPFILES) $(GENFILES) $(TEXFILES) $(PKG).tar.gz
