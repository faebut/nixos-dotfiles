{pkgs, ...}: {
  imports = [
  ];

  # COSMIC Desktop Environment
  # Note: Display manager (gdm) is configured per-host
  services.desktopManager.cosmic.enable = true;

  # xdg desktop portal
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-cosmic];
  };

  # COSMIC-related packages
  environment.systemPackages = with pkgs; [
    # Core COSMIC applications
    cosmic-term # terminal
    cosmic-edit # text editor
    cosmic-files # file manager
    cosmic-store # app store
    cosmic-reader # document viewer
    
    # COSMIC utilities
    cosmic-screenshot
    cosmic-settings
    cosmic-wallpapers
    cosmic-icons
    
    # Extensions
    cosmic-ext-tweaks
    cosmic-ext-calculator
  ];
}
