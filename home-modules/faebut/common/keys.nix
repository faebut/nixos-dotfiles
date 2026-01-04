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
    # NOTE: Age key is NOT deployed from sops - it must exist on disk before
    # sops can decrypt anything. This creates a circular dependency.
    #
    # BOOTSTRAP NEW MACHINE WITH YUBIKEY:
    # 1. Ensure age-plugin-yubikey is installed (in home-modules/common.nix)
    # 2. YubiKey must have age identity generated (age-plugin-yubikey --generate)
    # 3. YubiKey public key must be in nix-secrets/.sops.yaml recipients
    # 4. On new machine, decrypt with YubiKey:
    #      age-plugin-yubikey --identity > /tmp/yubikey-age-identity.txt
    #      SOPS_AGE_KEY_FILE=/tmp/yubikey-age-identity.txt sops -d ~/nix-secrets/secrets.yaml
    # 5. Extract this machine's age key from secrets.yaml (keys/age/${hostname})
    # 6. Save to ~/.config/sops/age/keys.txt with chmod 600
    # 7. Future rebuilds work without YubiKey
  };

  # Import GPG key from sops on activation
  home.activation.importGpgKey = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ -f "${config.home.homeDirectory}/.gnupg/imported-key.asc" ]; then
      $DRY_RUN_CMD ${pkgs.gnupg}/bin/gpg --batch --import "${config.home.homeDirectory}/.gnupg/imported-key.asc" 2>/dev/null || true
    fi
  '';

  # Add GPG authentication subkey to sshcontrol so gpg-agent exposes it for SSH
  home.activation.setupSshControl = config.lib.dag.entryAfter ["importGpgKey"] ''
    SSHCONTROL="${config.home.homeDirectory}/.gnupg/sshcontrol"
    # Extract keygrip of authentication subkey (usage: [A])
    KEYGRIP=$(${pkgs.gnupg}/bin/gpg --with-keygrip --list-secret-keys | ${pkgs.gnugrep}/bin/grep -A1 "\[A\]" | ${pkgs.coreutils}/bin/tail -n1 | ${pkgs.gawk}/bin/awk '{print $3}')
    
    if [ -n "$KEYGRIP" ]; then
      # Only add if not already present
      if ! ${pkgs.gnugrep}/bin/grep -q "$KEYGRIP" "$SSHCONTROL" 2>/dev/null; then
        $DRY_RUN_CMD echo "$KEYGRIP" >> "$SSHCONTROL"
      fi
    fi
  '';

  # Store public keys for reference
  home.file.".ssh/shared-gpg-ssh.pub".source = "${secretspath}/keys/shared-gpg-ssh.pub";
  home.file.".config/age/${hostname}-age.pub".source = "${secretspath}/keys/${hostname}-age.pub";
  
  # VPN configuration file
  home.file.".config/openvpn/si.ovpn".source = "${secretspath}/vpn/si.ovpn";
}
