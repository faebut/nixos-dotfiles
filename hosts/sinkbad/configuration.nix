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
    ../../nixos/desktop/displaymanagers/ly.nix
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

  # Use the systemd-boot EFI boot loader. configure plymouth
  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.consoleMode = "max"; # Use highest resolution for HiDPI
    loader.efi.canTouchEfiVariables = true;

    # Use latest kernel for Lunar Lake support
    kernelPackages = pkgs.linuxPackages_latest;

    # NOTE: Hibernation configuration (uncomment after first boot and getting resume_offset):
    # resumeDevice = "/dev/disk/by-label/nixos";
    # kernelParams = [ "resume_offset=XXXXX" ];  # Get from: sudo filefrag -v /swapfile
  };

  networking.hostName = "sinkbad"; # Define your hostname.

  # Display scaling for this machine
  displayScaling = "1.8";

  # Console settings with Catppuccin Mocha colors
  console = {
    earlySetup = true;
    font = "${pkgs.kbd}/share/consolefonts/latarcyrheb-sun32.psfu.gz";
    colors = [
      "1e1e2e" # 0: black (Base - proper background)
      "f38ba8" # 1: red
      "a6e3a1" # 2: green
      "f9e2af" # 3: yellow
      "89b4fa" # 4: blue
      "f5c2e7" # 5: magenta
      "94e2d5" # 6: cyan
      "cdd6f4" # 7: white (Text)
      "585b70" # 8: bright black (Surface2)
      "f38ba8" # 9: bright red
      "a6e3a1" # 10: bright green
      "f9e2af" # 11: bright yellow
      "89b4fa" # 12: bright blue
      "f5c2e7" # 13: bright magenta
      "94e2d5" # 14: bright cyan
      "cdd6f4" # 15: bright white (Text)
    ];
  };
  yubikey.enable = true;

  # ZSA keyboard support
  hardware.keyboard.zsa.enable = true;
  environment.systemPackages = with pkgs; [keymapp];
}
