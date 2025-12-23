{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    filen-cli # filen command line client
    filen-desktop # filen desktop tool
  ];
}
