{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    libreoffice-bin # libreoffice
    pdfarranger # manipulate pdfs
  ];
}
