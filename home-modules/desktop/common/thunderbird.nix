{
  pkgs,
  vars,
  config,
  lib,
  inputs,
  ...
}: let
  secretspath = builtins.toString inputs.nix-secrets;

  # Catppuccin Mocha Lavender theme
  catppuccin-mocha = pkgs.stdenv.mkDerivation {
    pname = "thunderbird-catppuccin-mocha-lavender";
    version = "0.1.0";

    src = pkgs.fetchurl {
      url = "https://github.com/catppuccin/thunderbird/raw/main/themes/mocha/mocha-lavender.xpi";
      sha256 = "0mpqgh4bafx0w806hmsgy0js38z2a8sxn6y6sdzmnspzlb7a89xg";
    };

    preferLocalBuild = true;
    allowSubstitutes = true;

    buildCommand = ''
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p "$dst"
      install -v -m644 "$src" "$dst/{e3f32d78-0bfe-51f7-a93b-6da02ca3c2c9}.xpi"
    '';
  };
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

        # Install Catppuccin Mocha theme
        extensions = [catppuccin-mocha];

        settings = {
          # Privacy
          "toolkit.telemetry.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;

          # Mail behavior
          "mail.shell.checkDefaultClient" = false;
          "mail.startup.enabledMailCheckOnce" = true;

          # Composition
          "mail.identity.default.reply_on_top" = 1; # Reply above quotes
          "mail.identity.default.sig_on_reply" = true; # Include signature
          "mail.identity.default.sig_bottom" = false; # Signature between reply and quotes

          # Auto-enable extensions
          "extensions.autoDisableScopes" = 0;

          # Theme
          "extensions.activeThemeID" = "{e3f32d78-0bfe-51f7-a93b-6da02ca3c2c9}";
        };
      };
    };
  };
}
