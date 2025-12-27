{
  config,
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}: let
  secretspath = builtins.toString inputs.nix-secrets;
  hostname = osConfig.networking.hostName;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  # Declare secrets needed
  sops.secrets = {
    "keys/gpg/shared_ssh_key" = {
      path = "${config.home.homeDirectory}/.gnupg/imported-key.asc";
    };
    "keys/age/${hostname}" = {
      path = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };
  };

  # Import GPG key from sops on activation
  home.activation.importGpgKey = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ -f "${config.home.homeDirectory}/.gnupg/imported-key.asc" ]; then
      $DRY_RUN_CMD ${pkgs.gnupg}/bin/gpg --batch --import "${config.home.homeDirectory}/.gnupg/imported-key.asc" 2>/dev/null || true
    fi
  '';

  # Store public keys for reference
  home.file.".ssh/shared-gpg-ssh.pub".source = "${secretspath}/keys/shared-gpg-ssh.pub";
  home.file.".config/age/${hostname}-age.pub".source = "${secretspath}/keys/${hostname}-age.pub";
}
