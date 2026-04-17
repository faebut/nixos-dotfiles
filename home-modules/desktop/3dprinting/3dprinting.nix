{pkgs, unstablePkgs, ...}: {
  home.packages = [
    pkgs.orca-slicer
    unstablePkgs.lycheeslicer
  ];
}
