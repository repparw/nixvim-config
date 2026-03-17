{
  pkgs,
  lib,
  ...
}:
{
  plugins.vimtex = {
    enable = true;
    texlivePackage = null;
    settings = {
      compiler_method = "latexmk";
      compiler_engine = "xelatex";
      bibtex_options = "--min-crossrefs=999";
      compiler_latexmk = {
        options = [
          "-synctex=1"
          "-interaction=nonstopmode"
          "-file-line-error"
        ];
      };
    };
  };
}
