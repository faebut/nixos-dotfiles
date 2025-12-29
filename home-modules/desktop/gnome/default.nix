# GNOME-specific home-manager configuration
{pkgs, ...}: {
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
    
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "kitty.desktop"
        "org.gnome.Console.desktop"
      ];
      
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };
  };

  # GNOME-compatible packages (excluding Hyprland/Wayland-specific tools)
  home.packages = with pkgs; [
    # Extensions
    gnomeExtensions.appindicator
  ];
}
