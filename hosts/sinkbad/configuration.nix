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
    # Display manager
    ../../nixos/desktop/displaymanagers/gdm.nix
  ];

  # ACPI handlers for ThinkPad function keys (sinkbad-specific)
  # These keys don't generate XF86 keysyms by default on ThinkPad X1 13th gen
  # ACPI events bypass the compositor and work reliably
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
      screenshot = {
        event = "button/printscreen";
        action = ''
          ${pkgs.systemd}/bin/systemd-run --machine=faebut@.host --user --setenv=WAYLAND_DISPLAY=$WAYLAND_DISPLAY ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)"
        '';
      };
    };
  };

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
