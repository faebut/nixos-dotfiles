{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    libreoffice # libreoffice
    pdfarranger # manipulate pdfs
  ];
}
