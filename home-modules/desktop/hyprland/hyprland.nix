{
  pkgs,
  config,
  osConfig,
  ...
}: {
  # additional packages
  home.packages = with pkgs; [
    hyprpicker
    hyprpwcenter
    hyprgraphics

    grim # screenshots
    wl-clipboard # clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # set the flake package
    package = null;
    portalPackage = null;
    extraConfig =
      ''
        monitor=eDP-1,preferred,0x0,${osConfig.displayScaling}
      ''
      + builtins.readFile ../../../config/hypr/hyprland.conf;
  };

  services.hyprpolkitagent.enable = true;

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

  # hyprlock - screen lock
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 1;
        fractional_scaling = 1;
      };

      auth = {
        "fingerprint:enabled" = true;
        "fingerprint:ready_message" = "scan finger for login";
        "fingerprint:present_message" = "scanning...";
      };

      background = [
        {
          monitor = "";
          path = "~/.config/hypr/wallpapers/blockwavemoon.png";
          color = "rgba(25, 20, 20, 1.0)";
          blur_passes = 0;
          blur_size = 7;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%-I:%M%p")"'';
          color = "rgba(180, 249, 248, 0.6)";
          font_size = 240;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 75";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.5;
          dots_center = true;
          inner_color = "rgba(26, 27, 38, 0.9)";
          outer_color = "rgba(187, 154, 247, 1)";
          font_color = "rgba(187, 154, 247, 1)";
          fade_on_empty = false;
          font_family = "JetBrains Mono Nerd Font Mono";
          placeholder_text = "Password or Fingerprint ...";
          hide_input = false;
          position = "0, -300";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # hypridle - idle daemon
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 450;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  systemd.user.services.hyprpaper = {
    Unit = {
      After = ["hyprland-session.target"];
      Requires = ["hyprland-session.target"];
    };
    Install = {
      WantedBy = ["hyprland-session.target"];
    };
  };

  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = ["~/.config/hypr/wallpapers/sunken-tower.png"];
      wallpaper = [
        "eDP-1, ~/.config/hypr/wallpapers/sunken-tower.png"
        "DP-4, ~/.config/hypr/wallpapers/sunken-tower.png"
      ];
    };
  };

  # clipboard manager
  services.cliphist = {
    enable = true;
    package = pkgs.cliphist;
    allowImages = true;
    clipboardPackage = pkgs.wl-clipboard;
    extraOptions = [
      "-max-dedupe-search"
      "100"
      "-max-items"
      "500"
    ];
  };

  # INFO: link config files individually to allow hyprsunset to generate its config
  home.file = {
    ".config/hypr/hyprtheme.conf".source = ../../../config/hypr/hyprtheme.conf;
    ".config/hypr/pyprland.json".source = ../../../config/hypr/pyprland.json;
    ".config/hypr/scripts".source = ../../../config/hypr/scripts;
    ".config/hypr/themes".source = ../../../config/hypr/themes;
    ".config/hypr/wallpapers".source = ../../../config/hypr/wallpapers;
    ".config/hypr/waybar".source = ../../../config/hypr/waybar;
  };
}
