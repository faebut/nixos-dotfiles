{pkgs, ...}: {
  home.packages = with pkgs; [
    # Just install LibreOffice and dictionaries
    libreoffice-fresh
    hunspellDicts.de_CH
    hyphenDicts.de_CH
    
    pdfarranger # manipulate pdfs
  ];
}
