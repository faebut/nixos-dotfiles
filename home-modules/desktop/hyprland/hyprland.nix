{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    # set the flake package
    package = null;
    portalPackage = null;
  };

  # blue light filter
  # TODO: maybe change to something more dynamic
  services.hyprsunset = {
    enable = true;
    package = pkgs.hyprsunset;
    settings = {
      max-gamma = 100;

      profile = [
        {
          time = "7:30";
          identity = true;
        }
        {
          time = "19:00";
          temperature = 3500;
          gamma = 0.8;
        }
      ];
    };
  };

  # INFO: link config files individually to allow hyprsunset to generate its config
  home.file = {
    ".config/hypr/hypridle.conf".source = ../../../config/hypr/hypridle.conf;
    ".config/hypr/hyprland.conf".source = ../../../config/hypr/hyprland.conf;
    ".config/hypr/hyprlock.conf".source = ../../../config/hypr/hyprlock.conf;
    ".config/hypr/hyprpaper.conf".source = ../../../config/hypr/hyprpaper.conf;
    ".config/hypr/hyprtheme.conf".source = ../../../config/hypr/hyprtheme.conf;
    ".config/hypr/pyprland.json".source = ../../../config/hypr/pyprland.json;
    ".config/hypr/scripts".source = ../../../config/hypr/scripts;
    ".config/hypr/themes".source = ../../../config/hypr/themes;
    ".config/hypr/wallpapers".source = ../../../config/hypr/wallpapers;
    ".config/hypr/waybar".source = ../../../config/hypr/waybar;
  };
}
