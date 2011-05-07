LATEX = pdflatex
AFMTOTFM = afm2tfm
INSTALL = install
INSTALLDIR = $(INSTALL) -d
INSTALLDATA = $(INSTALL) -m 644

PKG := ccicons
INSTFILES := $(PKG).pfb $(PKG).tfm $(PKG)-u.enc $(PKG).map README.ctan $(PKG).pdf
SRCFILES := $(PKG).ins $(PKG).dtx
TEXFILES := $(PKG).sty u$(PKG).fd
TEMPFILES := $(PKG).aux $(PKG).log $(PKG).idx $(PKG).ilg $(PKG).ind $(PKG).glo $(PKG).gls
TEXMFDIR := $(shell kpsewhich -expand-var='$$TEXMFHOME')

.PHONY: all metrics package doc ctan install uninstall clean

all: package

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

$(PKG).tar.gz: all $(INSTFILES)
	mkdir -p ctan/$(PKG)
	cp $(SRCFILES) $(INSTFILES) ctan/$(PKG)
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
	cd ctan/$(PKG) && mv README.ctan README
	(cd ctan && tar -c *) | gzip - > $(PKG).tar.gz
	rm -rf ctan

install: all $(INSTFILES)
	$(INSTALLDIR) $(TEXMFDIR)/tex/fonts/enc/dvips/$(PKG)
	$(INSTALLDATA) $(PKG)-u.enc $(TEXMFDIR)/tex/fonts/enc/dvips/$(PKG)
	$(INSTALLDIR) $(TEXMFDIR)/tex/fonts/map/dvips/$(PKG)
	$(INSTALLDATA) $(PKG).map $(TEXMFDIR)/tex/fonts/map/dvips/$(PKG)
	$(INSTALLDIR) $(TEXMFDIR)/tex/fonts/tfm/public/$(PKG)
	$(INSTALLDATA) $(PKG).tfm $(TEXMFDIR)/tex/fonts/tfm/public/$(PKG)
	$(INSTALLDIR) $(TEXMFDIR)/tex/fonts/type1/public/$(PKG)
	$(INSTALLDATA) $(PKG).pfb $(TEXMFDIR)/tex/fonts/type1/public/$(PKG)
	$(INSTALLDIR) $(TEXMFDIR)/tex/latex/$(PKG)
	$(INSTALLDATA) $(TEXFILES) $(TEXMFDIR)/tex/latex/$(PKG)
	$(INSTALLDIR) $(TEXMFDIR)/doc/latex/$(PKG)
	$(INSTALLDATA) $(PKG).pdf $(TEXMFDIR)/doc/latex/$(PKG)

uninstall:
	rm -rf $(TEXMFDIR)/tex/fonts/enc/dvips/$(PKG)
	rm -rf $(TEXMFDIR)/tex/fonts/map/dvips/$(PKG)
	rm -rf $(TEXMFDIR)/tex/fonts/tfm/public/$(PKG)
	rm -rf $(TEXMFDIR)/tex/fonts/type1/public/$(PKG)
	rm -rf $(TEXMFDIR)/tex/latex/$(PKG)
	rm -rf $(TEXMFDIR)/doc/latex/$(PKG)

clean:
	rm -f $(TEMPFILES) $(TEXFILES) $(PKG).tar.gz
