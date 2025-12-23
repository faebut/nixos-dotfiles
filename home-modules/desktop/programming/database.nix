{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    pgmodeler # TODO: we have subscription, this is the free version
    # TODO: somehow add luna modeler

    beekeeper-studio # db viewer
  ];
}
