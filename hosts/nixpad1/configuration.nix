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

  environment.systemPackages = with pkgs; [
    # your host-specific packages here
    acpid
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ACPI
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

  networking.hostName = "nixpad1"; # Define your hostname.

  yubikey.enable = true;
}
