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
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NOTE: Hibernation configuration (uncomment after first boot and getting resume_offset):
  # boot.resumeDevice = "/dev/disk/by-label/nixos";
  # boot.kernelParams = [ "resume_offset=XXXXX" ];  # Get from: sudo filefrag -v /swapfile

  networking.hostName = "nixps15"; # Define your hostname.

  # Display scaling for Dell XPS 15 (Full HD display, not 4K)
  displayScaling = "1.0";

  yubikey.enable = true;
}
