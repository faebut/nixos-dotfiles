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

  networking.hostName = "sinkbad"; # Define your hostname.

  # Console settings for high resolution
  console = {
    font = "ter-132n";
    packages = [ pkgs.terminus_font ];
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # display manager
  services.displayManager.ly.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.faebut = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # add insecure packages if necessary
  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.3.4"
  ];

  system.stateVersion = "25.11";

}
