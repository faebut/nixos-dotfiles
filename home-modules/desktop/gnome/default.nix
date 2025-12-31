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
    
    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer"];
    };
  };

  # GNOME-compatible packages (excluding Hyprland/Wayland-specific tools)
  home.packages = with pkgs; [
    # Extensions
    gnomeExtensions.appindicator
  ];
  
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
