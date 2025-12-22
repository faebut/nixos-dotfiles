# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# shared default config for all hosts
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_CH.UTF-8";
    LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8";
    LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8";
    LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8";
    LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };

  console = {
    # font = "ter-v22n";
    keyMap = "sg";
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "ch";

  # services
  services.gvfs.enable = true;
  services.printing.enable = true;

  # network management
  networking.networkmanager.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # firmware updates
  services.fwupd.enable = true;

  # default applications
  environment.systemPackages = with pkgs; [
    wget
    gcc
    unzip
    age
    sops
    pulseaudio # for audio
    wireplumber
    nh # nix cli helper
  ];

  # editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # shell
  programs.zsh.enable = true;

  # default installed fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts
  ];

  # add insecure packages if necessary
  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.3.4"
    "jitsi-meet-1.0.8792"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
