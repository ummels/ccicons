# ccicons
### Typesetting Creative Commons icons using LaTeX

This package offers authors who want to publish their documents under
a [Creative Commons](https://creativecommons.org) license an easy way to
include the relevant icons in their documents.

## Usage

To use this package, include

    \usepackage{ccicons}

in the preamble of your LaTeX document. See the
[PDF documentation](ccicons.pdf) for the details.

## Installation

Building the fonts requires fontforge and afm2tfm.

To install the fonts, the accompanying LaTeX package and the documentation in
your home texmf tree, run:

    make install

If you want to use a different texmf tree, you can specify it using the
variable TEXMFDIR:

    make install TEXMFDIR=/usr/local/texlive/texmf-local

Afterwards, make sure to update the file database using `mktexlsr` or
`texhash` (the command may vary depending on what distribution you use).

Finally, you need to activate the map file `fdsymbol.map`. For TeX Live, this
can be achieved by the following command:

    updmap-user --enable Map=fdsymbol.map

For installation in a system-wide texmf tree, replace `updmap-user` by
`updmap-sys`.

Make sure you have read https://tug.org/texlive/scripts-sys-user.html before
invoking `updmap-user`.

## License

Copyright (C) 2011-2025 by Michael Ummels <michael@ummels.de>

The font components of this software, e.g. FontForge (.sfd), OpenType (.otf),
TeX font metric (.tfm), and Type 1 (.pfb) files, are licensed under the
[SIL Open Font License](https://openfontlicense.org), Version 1.1.

The symbols in this font have been obtained from
<https://creativecommons.org/mission/downloads/>
and are subject to the
[Creative Commons Trademark Policy](https://creativecommons.org/policies/).

The LaTeX support files contained in this software may be modified and
distributed under the terms and conditions of the
[LaTeX Project Public License](https://www.latex-project.org/lppl/),
version 1.3c or greater (your choice).

This work has the LPPL maintenance status `maintained'.

The Current Maintainer of this work is Michael Ummels.

This work consists of the files ccicons.dtx, ccicons.ins,
and the derived files ccicons.pdf and ccicons.sty.

All other files distributed with these sources, e.g. the Makefile,
are in the public domain.
