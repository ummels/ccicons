# ccicons

### Typesetting Creative Commons icons using LaTeX

This package offers authors who want to publish their documents under
a [Creative Commons](https://creativecommons.org) license an easy way to
include the relevant icons in their documents.

## Usage

To use this package, include

    \usepackage{ccicons}

in the preamble of your LaTeX document. See the
[PDF documentation](https://ummels.github.io/ccicons/ccicons.pdf)
for the details.

## Installation

The font and the corresponding LaTeX support package are best installed through
the package manager of a TeX distribution such as
[TeX Live](https://www.tug.org/texlive/) or MiKTeX.

## Build instructions

Building the font yourself requires [FontForge](https://fontforge.org/) and can
be accomplished by running:

     make font

To build the LaTeX package and the documentation and install everything into
your home texmf tree, run:

    l3build install --full

Finally, you need to activate the map file `ccicons.map`. If you use TeX Live,
this can be achieved by the following command:

    updmap-user --enable Map=ccicons.map

Make sure you have read https://tug.org/texlive/scripts-sys-user.html before
invoking `updmap-user`.

## License

Copyright (C) 2011-2026 by Michael Ummels <michael@ummels.de>

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
