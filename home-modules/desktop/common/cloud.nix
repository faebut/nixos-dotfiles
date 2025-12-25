{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
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
      ExecStart = "${pkgs.filen-cli}/bin/filen mount %h/Cloud/Filen";
      ExecStopPost = "${pkgs.fuse}/bin/fusermount -uz %h/Cloud/Filen";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
