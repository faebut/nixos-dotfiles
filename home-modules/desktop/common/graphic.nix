{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    gimp # image manipulator
    inkscape # vector images

    adwaita-icon-theme # theme to fix missing icons
  ];
}
