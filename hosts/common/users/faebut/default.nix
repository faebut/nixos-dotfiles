{
  config,
  lib,
  pkgs,
  ...
}: {
  # get password
  sops.secrets.faebut-pass.neededForUsers = true;
  users.mutableUsers = false;

  users.users.faebut = {
    description = "faebut";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd" # for virt-manager
      "input" # for direct input device access (ThinkPad extra buttons, etc.)
    ];
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = [
    # ];
    hashedPasswordFile = config.sops.secrets.faebut-pass.path;
  };

  # sudo pw timeout
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=120 # only ask for password every 120 minutes
  '';
}
