{
  pkgs,
  unstablePkgs,
  ...
}: {
  imports = [
  ];

  # Enable the display and window manager
  services.displayManager.ly = {
    enable = true;
    package = unstablePkgs.ly; # TUI -- zig -- https://codeberg.org/AnErrupTion/ly
    # x11Support = true;
    settings = {
      auth_fails = 3; # special animation looks broken?
      bg = "0x000E1013";
      bigclock = "en"; # enlarges the clock -- may not work with some fonts?
      border_fg = "0x00BF68D9";
      box_title = "null"; # text above the box
      clear_password = true;
      clock = "%B, %A %d @ %H:%M:%S";
      default_input = "password";
      error_bg = "0x000E1013";
      error_fg = "0x01E55561";
      fg = "0x01A0A8B7";
      hide_borders = true;
      hide_version_string = true; # doesnt work?
      hide_key_hints = true;
      lang = "en";
      load = true;
      margin_box_h = 0;
      margin_box_v = 0;
      min_refresh_delta = 100; # milliseconds -- default=5
      save = true;
      text_in_center = false; # ugly
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # maybe needed?
  security.polkit.enable = true;
}
