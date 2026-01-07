# GNOME-specific home-manager configuration
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common/rclone.nix # OneDrive access for nixps15
  ];

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
        "search-light@icedman.github.com"
      ];
    };

    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer"];
    };

    # Window manager keybindings
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
      switch-input-source = []; # Disable Super+Space for keyboard switching
      switch-input-source-backward = [];
    };

    # Search Light extension settings
    "org/gnome/shell/extensions/search-light" = {
      shortcut-search = ["<Super>space"];
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

  # GNOME autostart applications
  xdg.configFile."autostart/ferdium.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Ferdium
    Comment=Messaging Application
    Exec=ferdium --hidden %U
    Icon=ferdium
    Categories=Network;InstantMessaging;
    StartupWMClass=Ferdium
    X-GNOME-Autostart-enabled=true
  '';

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

  # Monitor configuration managed by GNOME directly
  # Set via Settings > Displays in GNOME
  # GNOME persists configuration in ~/.config/monitors.xml automatically
}
