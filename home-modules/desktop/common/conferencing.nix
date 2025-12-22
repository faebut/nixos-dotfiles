{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    jitsi-meet # jitsi meet client
  ];
}
