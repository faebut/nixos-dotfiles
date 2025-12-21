{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    # set the flake package
    package = null;
    portalPackage = null;
  };
}
