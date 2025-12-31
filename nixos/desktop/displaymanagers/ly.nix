{unstablePkgs, ...}: {
  services.displayManager.ly = {
    enable = true;
    package = unstablePkgs.ly; # TUI https://codeberg.org/AnErrupTion/ly
    settings = {
      auth_fails = 3;
      bigclock = "en";
      box_title = "null";
      clear_password = true;
      clock = "%B, %A %d @ %H:%M:%S";
      default_input = "password";
      hide_borders = true;
      hide_version_string = true;
      hide_key_hints = true;
      lang = "en";
      load = true;
      margin_box_h = 0;
      margin_box_v = 0;
      min_refresh_delta = 100;
      save = true;
      term_reset_cmd = "tput reset";
      text_in_center = false;
    };
  };

  environment.systemPackages = [
    unstablePkgs.ly
  ];
}
