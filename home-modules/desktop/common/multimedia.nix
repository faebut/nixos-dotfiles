{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    obs-studio # obs live streaming
    audacity # audio editor
    mpv # new mplayer fork
    transmission_4-gtk # torrent client
    proton-vpn # proton vpn for protection
  ];
}
