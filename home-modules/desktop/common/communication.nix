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

  # Override Ferdium to start minimized
  xdg.desktopEntries.ferdium = {
    name = "Ferdium";
    genericName = "Messaging Application";
    exec = "ferdium --hidden %U";
    icon = "ferdium";
    type = "Application";
    categories = ["Network" "InstantMessaging"];
    settings = {
      StartupWMClass = "Ferdium";
    };
  };

  # Override Slack to start minimized and disable Ozone (fixes graphical artifacts when maximized)
  xdg.desktopEntries.slack = {
    name = "Slack";
    genericName = "Team Communication";
    exec = "slack -u --disable-features=WaylandWindowDecorations --ozone-platform=x11 %U";
    icon = "slack";
    type = "Application";
    categories = ["Network" "InstantMessaging"];
    settings = {
      StartupWMClass = "Slack";
    };
  };
}
