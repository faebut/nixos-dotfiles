# GNOME-specific home-manager configuration
{
  pkgs,
  lib,
  ...
}: {
  # GNOME desktop configuration
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    # GNOME Shell theme (requires user-themes extension)
    "org/gnome/shell/extensions/user-theme" = {
      name = "Nordic";
    };

    "org/gnome/shell" = {
      # favorite-apps = [
      #   "org.gnome.Nautilus.desktop"
      #   "zen.desktop"
      #   "kitty.desktop"
      #   "org.gnome.Console.desktop"
      # ];

      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "trayIconsReloaded@selfmade.pl"
        "search-light@icedman.github.com"
      ];
    };

    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer"];
    };

    # Window manager keybindings
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
    };

    # Custom keyboard shortcuts
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kitty";
      name = "Open Kitty Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>e";
      command = "nautilus --new-window";
      name = "Open Nautilus File Manager";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>b";
      command = "zen";
      name = "Open Zen Browser";
    };
  };

  # GNOME-compatible packages
  home.packages = with pkgs; [
    # Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.search-light

    # Clipboard tool for tmux integration on Wayland
    wl-clipboard

    # Tool to change papirus folder colors
    papirus-folders
  ];

  # GTK theme configuration for GNOME (nixps15)
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
    iconTheme = {
      package = pkgs.papirus-nord;
      name = "Papirus-Dark";
    };
    gtk2 = {
      enable = true;
      theme = {
        package = pkgs.nordic;
        name = "Nordic";
      };
    };
    gtk3 = {
      enable = true;
      theme = {
        package = pkgs.nordic;
        name = "Nordic";
      };
    };
    gtk4 = {
      enable = true;
      colorScheme = "dark";
      theme = {
        package = pkgs.nordic;
        name = "Nordic";
      };
    };
  };

  # Monitor configuration
  # Note: You'll need to get your monitor identifiers first by running:
  # gsettings get org.gnome.desktop.monitors
  # Then configure monitors.xml manually or use autorandr
  home.file.".config/monitors.xml" = {
    text = ''
      <monitors version="2">
        <configuration>
          <logicalmonitor>
            <x>0</x>
            <y>0</y>
            <scale>1</scale>
            <primary>no</primary>
            <monitor>
              <monitorspec>
                <connector>eDP-1</connector>
                <vendor>unknown</vendor>
                <product>unknown</product>
                <serial>unknown</serial>
              </monitorspec>
              <mode>
                <width>1920</width>
                <height>1080</height>
                <rate>60</rate>
              </mode>
            </monitor>
          </logicalmonitor>
          <logicalmonitor>
            <x>1920</x>
            <y>0</y>
            <scale>1</scale>
            <primary>yes</primary>
            <monitor>
              <monitorspec>
                <connector>HDMI-1</connector>
                <vendor>unknown</vendor>
                <product>unknown</product>
                <serial>unknown</serial>
              </monitorspec>
              <mode>
                <width>1920</width>
                <height>1080</height>
                <rate>60</rate>
              </mode>
            </monitor>
          </logicalmonitor>
        </configuration>
      </monitors>
    '';
  };
}
