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
    # Display manager
    ../../nixos/desktop/displaymanagers/gdm.nix
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.appindicator
    keymapp
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Plymouth boot splash with graphical LUKS password prompt
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  # Required for Plymouth to work properly with LUKS
  boot.initrd.systemd.enable = true;

  # Enable silent boot for cleaner Plymouth experience
  boot.kernelParams = [
    "quiet"
    "splash"
    "resume_offset=72843264"
  ];

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  # Hibernation configuration
  boot.resumeDevice = "/dev/disk/by-label/nixos";

  networking.hostName = "nixps15"; # Define your hostname.

  # Display scaling for Dell XPS 15 (Full HD display, not 4K)
  displayScaling = "1.0";

  yubikey.enable = true;

  # ZSA keyboard support
  hardware.keyboard.zsa.enable = true;
}
