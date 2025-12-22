{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    gimp # image manipulator
    inkscape # vector images
  ];
}
