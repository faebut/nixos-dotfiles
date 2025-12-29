# host specific configuration
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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel for Lunar Lake support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # NOTE: Hibernation configuration (uncomment after first boot and getting resume_offset):
  # boot.resumeDevice = "/dev/disk/by-label/nixos";
  # boot.kernelParams = [ "resume_offset=XXXXX" ];  # Get from: sudo filefrag -v /swapfile

  networking.hostName = "sinkbad"; # Define your hostname.

  # Display scaling for this machine
  displayScaling = "1.8";

  # Console settings for high resolution
  console = {
    font = "ter-132n";
    packages = [pkgs.terminus_font];
  };

  yubikey.enable = true;
}
