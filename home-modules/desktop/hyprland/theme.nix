# GTK theme configuration for Hyprland hosts (nixpad1, sinkbad)
{pkgs, ...}: {
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      package = pkgs.qogir-theme;
      name = "Qogir-Dark";
    };
    iconTheme = let
      theme = (
        pkgs.colloid-icon-theme.override {
          colorVariants = ["purple"];
        }
      );
    in {
      package = theme;
      name = "Colloid-Purple-Dark";
    };
    gtk2 = {
      enable = true;
      theme = {
        package = pkgs.qogir-theme;
        name = "Qogir-Dark";
      };
    };
    gtk3 = {
      enable = true;
      theme = {
        package = pkgs.qogir-theme;
        name = "Qogir-Dark";
      };
    };
    gtk4 = {
      enable = true;
      colorScheme = "dark";
      theme = {
        package = pkgs.qogir-theme;
        name = "Qogir-Dark";
      };
    };
  };
}
