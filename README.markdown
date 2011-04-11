ccicons - Typesetting Creative Commons icons using LaTeX
========================================================

This package offers authors who want to publish their documents under
a [Creative Commons][CC] license an easy way to include the relevant icons
in their documents.

[CC]: http://creativecommons.org

Installation
------------

Building the TeX font metrics requires atf2tfm. To install the fonts, the
accompanying LaTeX package and the documentation in your home texmf tree, run:

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

Copyright (C) 2011 by Michael Ummels <michael.ummels@rwth-aachen.de>

This work may be distributed and/or modified under the
conditions of the LaTeX Project Public License, either version 1.3c
of this license or (at your option) any later version.
The latest version of this license is in
  http://www.latex-project.org/lppl.txt
and version 1.3 or later is part of all distributions of LaTeX
version 2005/12/01 or later.

This work has the LPPL maintenance status `maintained'.

The Current Maintainer of this work is Michael Ummels.

This work consists of the files ccicons.dtx, ccicons.ins,
ccicons.map, ccicons.pfb, ccicons.tfm, ccicons-u.enc and
the derived files ccicons.sty and uccicons.fd.

The files ccicons.pfb and ccicons.tfm have been
generated from the file cc-icons-svg.zip available from
http://mirrors.creativecommons.org/presskit/icons/cc-icons-svg.zip
and released by Creative Commons (http://creativecommons.org) under a
Creative Commons Attribution 3.0 Unported license
(http://creativecommons.org/licenses/by/3.0/).
