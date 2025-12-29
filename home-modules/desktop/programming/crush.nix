{
  inputs,
  config,
  ...
}:
let
  secretspath = builtins.toString inputs.nix-secrets;
in
{
  imports = [
    inputs.nur.homeModules.crush
    inputs.sops-nix.homeManagerModules.sops
  ];

  # TODO: this should not be here but for the user in home-manager
  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age = {
      keyFile = "/home/faebut/.config/sops/age/keys.txt";
    };

    secrets = {
      anthropic-api = { };
    };
  };

  programs.crush = {
    enable = true;
    settings = {
      providers = {
        anthropic = {
          id = "anthropic";
          name = "Anthropic";
          base_url = "https://api.anthropic.com";
          type = "anthropic";
          api_key = "cat ${config.sops.secrets."anthropic-api".path}";
          models = [
            {
              id = "claude-sonnet-4-5-20250929";
              name = "Claude Sonnet 4.5";
            }
            {
              id = "claude-3-5-haiku-20241022";
              name = "Claude Haiku 3.5";
            }
          ];
        };
      };
      lsp = {
        go = {
          command = "gopls";
          enabled = true;
        };
        nix = {
          command = "nixd";
          enabled = true;
        };
      };
      # options = {
      #   context_paths = [ "/etc/nixos/configuration.nix" ];
      #   tui = {
      #     compact_mode = true;
      #   };
      #   debug = false;
      # };
    };
  };
}
