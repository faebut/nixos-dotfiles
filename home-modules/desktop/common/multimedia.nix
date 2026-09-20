{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    obs-studio # obs live streaming
    audacity # audio editor
    mplayer # video player
    transmission_4-gtk # torrent client
    proton-vpn # proton vpn for protection
  ];
}
