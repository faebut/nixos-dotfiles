{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    jre
  ];
}
