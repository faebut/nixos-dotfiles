# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# shared default config for all hosts

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
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

  # virtual filesystems
  services.gvfs.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # default applications
  environment.systemPackages = with pkgs; [
    neovim
    wget
    gcc
    unzip
  ];

  programs.zsh.enable = true;

  # default nerd-font
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
