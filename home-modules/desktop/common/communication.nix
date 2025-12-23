{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    jitsi-meet-electron # jitsi meet client
    ferdium # multi client
    slack # slack
  ];
}
