{
  config,
  inputs,
  unstablePkgs,
  ...
}: let
  secretspath = builtins.toString inputs.nix-secrets;

  crushSettings = {
    "$schema" = "https://charm.land/crush.json";
    providers.anthropic = {
      api_key = "$(cat ${config.sops.secrets.anthropic-api.path})";
      models = [
        {
          id = "claude-opus-5-5";
          name = "Claude Opus 5.5 (200k)";
          can_reason = true;
          context_window = 200000;
          cost_per_1m_in = 4;
          cost_per_1m_in_cached = 5;
          cost_per_1m_out = 20;
          cost_per_1m_out_cached = 0.2;
          default_max_tokens = 32000;
          default_reasoning_effort = "medium";
          reasoning_levels = ["low" "medium" "high" "xhigh" "max"];
          supports_attachments = true;
        }
      ];
    };
    options.disable_auto_summarize = false;
  };
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

  xdg.configFile."crush/crush.json".text = builtins.toJSON crushSettings;
}
