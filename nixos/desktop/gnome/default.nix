{pkgs, ...}: {
  imports = [
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # Note: Display manager (gdm) is configured per-host
  services.desktopManager.gnome.enable = true;

  # GNOME-related packages
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    pika-backup # backup tool
    papers # document viewer
    foliate # epub reader
  ];

  # Remove unwanted packages
  environment.gnome.excludePackages = with pkgs; [
    baobab # disk usage analyzer
    cheese # photo booth
    eog # image viewer
    epiphany # web browser
    gedit # text editor
    totem # video player
    yelp # help viewer
    geary # email client
    gnome-tour
    gnome-calendar
    gnome-connections
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-logs
    gnome-maps
    gnome-music
    gnome-weather
  ];
}
