# host specific configuration

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel for Lunar Lake support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "sinkbad"; # Define your hostname.

  # Display scaling for this machine
  displayScaling = "1.75";

  # Console settings for high resolution
  console = {
    font = "ter-132n";
    packages = [ pkgs.terminus_font ];
  };

  yubikey.enable = true;
}
