{
  pkgs,
  vars,
  ...
}:
{
  programs.thunderbird = {
    enable = true;

    profiles = {
      faebut = {
        isDefault = true;

        # extraConfig = ''
        #   // Disable automatic updates for this profile
        #   user_pref("app.update.enabled", false);
        # '';
      };
    };
  };
}
