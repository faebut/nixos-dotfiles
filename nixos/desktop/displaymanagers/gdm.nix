{
  pkgs,
  ...
}: {
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  environment.systemPackages = with pkgs; [
    gnome-session
  ];
}
