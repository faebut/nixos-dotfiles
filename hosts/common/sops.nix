# sops config
{
  pkgs,
  inputs,
  config,
  ...
}:
let
  secretspath = builtins.toString inputs.nix-secrets;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age = {
      keyFile = "/home/faebut/.config/sops/age/keys.txt";
    };

    secrets = {
      anthropic-api = {
        owner = config.users.users.faebut.name;
        inherit (config.users.users.faebut) group;
      };
      faebut-pass = { };
    };
  };
}
