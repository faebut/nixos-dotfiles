{pkgs, ...}: {
  home.packages = with pkgs; [
    todoist-electron
  ];

  services.flatpak = {
    packages = [
      "io.vikunja.Vikunja"
    ];
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
