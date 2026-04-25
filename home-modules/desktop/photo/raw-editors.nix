{
  config,
  pkgs,
  unstablePkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # darktable
    rawtherapee
    # rapidraw
  ];
}
