{pkgs, ...}: {
  home.packages = with pkgs; [
    filezilla
    mc # midnight commander
    yazi
    lf
  ];
}
