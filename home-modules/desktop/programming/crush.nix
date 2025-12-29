{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  secretspath = builtins.toString inputs.nix-secrets;
  crushConfigFile = pkgs.writeShellScript "generate-crush-config" ''
    API_KEY=$(cat ${config.sops.secrets."anthropic-api".path})
    CONFIG_DIR="$HOME/.config/crush"
    mkdir -p "$CONFIG_DIR"
    
    # Remove read-only file if it exists
    rm -f "$CONFIG_DIR/crush.json"
    
    cat > "$CONFIG_DIR/crush.json" <<EOF
    {
      "lsp": {
        "go": {
          "args": [],
          "command": "gopls",
          "enabled": true,
          "options": {}
        },
        "nix": {
          "args": [],
          "command": "nixd",
          "enabled": true,
          "options": {}
        }
      },
      "mcp": {},
      "models": {},
      "options": {
        "context_paths": [],
        "data_directory": ".crush",
        "debug": false,
        "debug_lsp": false,
        "disable_auto_summarize": false,
        "tui": {
          "compact_mode": false
        }
      },
      "permissions": {
        "allowed_tools": []
      },
      "providers": {
        "anthropic": {
          "api_key": "$API_KEY",
          "base_url": "https://api.anthropic.com",
          "disable": false,
          "extra_body": {},
          "extra_headers": {},
          "id": "anthropic",
          "models": [
            {
              "can_reason": false,
              "context_window": 128000,
              "cost_per_1m_in": 0,
              "cost_per_1m_in_cached": 0,
              "cost_per_1m_out": 0,
              "cost_per_1m_out_cached": 0,
              "default_max_tokens": 8192,
              "default_reasoning_effort": "",
              "has_reasoning_efforts": false,
              "id": "claude-sonnet-4-5-20250929",
              "name": "Claude Sonnet 4.5",
              "supports_attachments": false
            },
            {
              "can_reason": false,
              "context_window": 128000,
              "cost_per_1m_in": 0,
              "cost_per_1m_in_cached": 0,
              "cost_per_1m_out": 0,
              "cost_per_1m_out_cached": 0,
              "default_max_tokens": 8192,
              "default_reasoning_effort": "",
              "has_reasoning_efforts": false,
              "id": "claude-3-5-haiku-20241022",
              "name": "Claude Haiku 3.5",
              "supports_attachments": false
            }
          ],
          "name": "Anthropic",
          "system_prompt_prefix": "",
          "type": "anthropic"
        }
      }
    }
    EOF
  '';
in {
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
      anthropic-api = {};
    };
  };

  home.activation.crushConfig = lib.hm.dag.entryAfter ["writeBoundary" "linkGeneration"] ''
    run rm -f $VERBOSE_ARG "$HOME/.config/crush/crush.json"
    run ${crushConfigFile}
  '';

  programs.crush = {
    enable = true;
    settings = {};
  };
}
