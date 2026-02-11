-- Build configuration for ccicons

module = "ccicons"

checkengines = {"pdftex", "luatex"}
ctanreadme = "README-CTAN.md"

sourcefiles = {"*.dtx", "*.ins", "*.sfd", "*.enc", "*.map", "*.pfb", "*.afm", "*.tfm", "*.otf"}
installfiles = {"*.sty", "*.enc", "*.map", "*.pfb", "*.afm", "*.tfm", "*.otf"}
binaryfiles = {"*.pdf", "*.zip", "*.pfb", "*.tfm", "*.otf"}
packtdszip = true
tdslocations =
  {
    "fonts/enc/dvips/ccicons/*.enc",
    "fonts/map/dvips/ccicons/*.map",
    "fonts/type1/public/ccicons/*.pfb",
    "fonts/afm/public/ccicons/*.afm",
    "fonts/tfm/public/ccicons/*.tfm",
    "fonts/opentype/public/ccicons/*.otf",
    "source/fonts/ccicons/*.sfd",
    "doc/fonts/ccicons/*.txt"
  }
