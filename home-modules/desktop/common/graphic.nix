{
  config,
  pkgs,
  unstablePkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    gimp # image manipulator
    inkscape # vector images

    adwaita-icon-theme # theme to fix missing icons
    inputs.affinity-nix.packages.x86_64-linux.affinity-v3 # affinity
  ];
}
