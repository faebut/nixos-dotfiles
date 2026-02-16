{
  inputs,
  unstablePkgs,
  ...
}: let
  secretspath = builtins.toString inputs.nix-secrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age = {
      keyFile = "/home/faebut/.config/sops/age/keys.txt";
    };

    secrets = {
      anthropic-api = {};
    };
  };

  home.packages = [
    unstablePkgs.crush
  ];
}
