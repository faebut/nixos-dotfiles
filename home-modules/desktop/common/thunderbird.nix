{
  pkgs,
  vars,
  config,
  lib,
  inputs,
  ...
}: let
  secretspath = builtins.toString inputs.nix-secrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    # Import account configuration from private repo
    "${secretspath}/thunderbird-accounts.nix"
  ];

  programs.thunderbird = {
    enable = true;

    profiles = {
      faebut = {
        isDefault = true;
      };
    };
  };
}
