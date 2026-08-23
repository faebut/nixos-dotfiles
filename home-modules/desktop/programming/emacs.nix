{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  home.packages = with pkgs; [
    fd
  ];
}
