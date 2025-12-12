{
  config,
  lib,
  pkgs,
  ...
}:
{
  # sops.secrets."users_faebut_password_hash".neededForUsers = true;

  users.users.faebut = {
    description = "faebut";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = [
    # ];
    # hashedPasswordFile = config.sops.secrets."users_faebut_password_hash".path;
  };
}
