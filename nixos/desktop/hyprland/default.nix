{
  pkgs,
  ...
}: {
  imports = [
  ];

  # Enable Hyprland window manager
  # Note: Display manager (ly/sddm/gdm) is configured per-host
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # xdg desktop portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # polkit
  security.polkit.enable = true;

  # gnome-keyring for secret storage (filen, etc.)
  services.gnome.gnome-keyring.enable = true;

  # packages

  environment.systemPackages = with pkgs; [
    # tools for hyprland
    # xdg-desktop-portal-hyprland # desktop portal
    hyprpolkitagent # polkit
    rofi # execute stuff
    waybar # top bar
    libnotify # send notifications
    swaynotificationcenter # show notifications
    brightnessctl # control brightness
    pamixer # control volume
    pyprland # scratchpads and so

    # other tools
    nautilus # file manager
    file-roller # archiver
    networkmanagerapplet # control networkmanager from applet
    seahorse # keyring manager

    # borrowed from gnome / kde
    sushi # quick preview
    loupe # image viewer
    papers # document viewer
  ];
}
