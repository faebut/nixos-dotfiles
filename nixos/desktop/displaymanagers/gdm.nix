{pkgs, ...}: {
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  environment.systemPackages = with pkgs; [
    gnome-session
  ];
}
