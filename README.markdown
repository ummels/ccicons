ccicons - Typesetting Creative Commons icons using LaTeX
========================================================

This package offers authors who want to publish their documents under
a [Creative Commons][CC] license an easy way to include the relevant icons
in their documents.

[CC]: http://creativecommons.org

Usage
-----

To use package, include

    \usepackage{ccicons}

in the preamble of your LaTeX document. See the PDF documentation for
the details.

Installation
------------

Building the fonts requires fontforge and afm2tfm.

To install the fonts, the accompanying LaTeX package and the documentation in
your home texmf tree, run:

    make install

If you want to use a different texmf tree, you can specify it using the
variable TEXMFDIR:

    make install TEXMFDIR=/usr/local/texlive/texmf-local

Afterwards, you may need to regenerate the file database:

    texhash

Finally, you need to activate the map file:

    updmap --enable Map=ccicons.map

For a system-wide installation, replace updmap by updmap-sys.

License
-------

Copyright (C) 2013 by Michael Ummels <michael.ummels@rwth-aachen.de>

The font components of this software, e.g. FontForge (.sfd), OpenType (.otf),
TeX font metric (.tfm), and Type 1 (.pfb) files, are licensed under the
[SIL Open Font License][OFL], Version 1.1.

[OFL]: http://scripts.sil.org/OFL

The symbols in this font have been taken from the file cc-icons-svg.zip
available from
<http://mirrors.creativecommons.org/presskit/icons/cc-icons-svg.zip>
and released by Creative Commons under the Creative Commons Attribution
3.0 Unported License: <http://creativecommons.org/licenses/by/3.0/>

The LaTeX support files contained in this software may be modified and
distributed under the terms and conditions of the
[LaTeX Project Public License][LPPL], version 1.3c or greater (your choice).

[LPPL]: http://www.latex-project.org/lppl/

This work has the LPPL maintenance status `maintained'.

The Current Maintainer of this work is Michael Ummels.

This work consists of the files ccicons.dtx, ccicons.ins,
and the derived files ccicons.pdf and ccicons.sty.

All other files distributed with these sources, e.g. the Makefile,
are in the public domain.
