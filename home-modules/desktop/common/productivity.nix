{pkgs, ...}: {
  home.packages = with pkgs; [
    # Just install LibreOffice and dictionaries
    libreoffice-fresh
    hunspellDicts.de_CH
    hyphenDicts.de_CH

    pdfarranger # manipulate pdfs
  ];

  programs.onlyoffice = {
    enable = true;

    package = pkgs.onlyoffice-desktopeditors;

    settings = {
      UITheme = "theme-night";
      editorWindowMode = false;
      locale = "de-CH";
    };
  };
}
