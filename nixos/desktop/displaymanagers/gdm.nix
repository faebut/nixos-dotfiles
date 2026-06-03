{pkgs, ...}: {
  services.displayManager.gdm = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnome-session
  ];
}
