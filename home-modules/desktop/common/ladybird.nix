# Ladybird browser from the official flatpak repo (prebuilt alpha releases).
# nixpkgs only ships an older unstable snapshot.
{
  services.flatpak = {
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "ladybird";
        location = "https://flatpak.ladybird.org/ladybird.flatpakrepo";
      }
    ];
    packages = [
      {
        appId = "org.ladybird.Ladybird";
        origin = "ladybird";
      }
    ];
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
