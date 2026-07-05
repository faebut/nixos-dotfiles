{pkgs, ...}: {
  home.packages = with pkgs; [
    gimp # image manipulator
    inkscape # vector images
    inkcut # standalone plotter software
    inkscape-extensions.inkcut # plotter plugin

    adwaita-icon-theme # theme to fix missing icons
    affinity-v3 # affinity
  ];
}
