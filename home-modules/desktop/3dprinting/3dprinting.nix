{
  config,
  pkgs,
  unstablePkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    orca-slicer
  ];
}
