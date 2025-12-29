# host specific configuration for Dell XPS 15 9500
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    acpid
    gnome-tweaks
    gnomeExtensions.appindicator
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NOTE: Hibernation configuration (uncomment after first boot and getting resume_offset):
  # boot.resumeDevice = "/dev/disk/by-label/nixos";
  # boot.kernelParams = [ "resume_offset=XXXXX" ];  # Get from: sudo filefrag -v /swapfile

  # ACPI for hardware buttons
  services.acpid = {
    enable = true;
    handlers = {
      mute = {
        event = "button/mute";
        action = ''
          ${pkgs.systemd}/bin/systemd-run --machine=faebut@.host --user ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        '';
      };
      volumedown = {
        event = "button/volumedown";
        action = ''
          ${pkgs.systemd}/bin/systemd-run --machine=faebut@.host --user ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- --limit 1.0
        '';
      };
      volumeup = {
        event = "button/volumeup";
        action = ''
          ${pkgs.systemd}/bin/systemd-run --machine=faebut@.host --user ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0
        '';
      };
      brightnessdown = {
        event = "video/brightnessdown";
        action = ''
          ${pkgs.brightnessctl}/bin/brightnessctl set --min-value=5 15-
        '';
      };
      brightnessup = {
        event = "video/brightnessup";
        action = ''
          ${pkgs.brightnessctl}/bin/brightnessctl set 15+
        '';
      };
    };
  };

  # GNOME Desktop Environment
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
  };

  # GDM Display Manager
  services.displayManager.gdm.enable = true;

  # Exclude some default GNOME applications
  environment.gnome.excludePackages = with pkgs; [
    epiphany # web browser
    geary # email client
    gnome-music
    gnome-photos
    simple-scan
    totem # video player
  ];

  networking.hostName = "nixps15"; # Define your hostname.

  # Display scaling for Dell XPS 15 (Full HD display, not 4K)
  displayScaling = "1.0";

  yubikey.enable = true;
}
