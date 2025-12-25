{
  inputs,
  config,
  pkgs,
  lib,
  unstablePkgs,
  ...
}:
let
  secretspath = builtins.toString inputs.nix-secrets;
in
let
  filenMountScript = pkgs.writeShellScript "filen-mount" ''
    ${pkgs.filen-cli}/bin/filen mount "$HOME/Cloud/Filen" \
      --email "$(cat ${config.sops.secrets.filen-email.path})" \
      --password "$(cat ${config.sops.secrets.filen-password.path})"
  '';
in
{
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
      filen-email = { };
      filen-password = { };
    };
  };

  home.packages = with pkgs; [
    filen-cli # filen command line client
  ];

  # Systemd user service to mount Filen cloud storage
  systemd.user.services.filen-mount = {
    Unit = {
      Description = "Filen cloud storage mount";
      After = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p %h/Cloud/Filen"
        "${pkgs.coreutils}/bin/rm -f %h/Cloud/Filen/.keep"
      ];
      ExecStart = "${filenMountScript}";
      ExecStopPost = "/run/wrappers/bin/fusermount -uz %h/Cloud/Filen";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
