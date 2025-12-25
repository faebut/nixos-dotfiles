{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  extension = shortId: guid: pinned: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
      default_area =
        if pinned
        then "navbar"
        else "menupanel";
    };
  };

  browserPrefs = {
    # Check these out at about:config
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;
    "browser.startup.homepage" = "https://nixos.org";
    "browser.search.defaultenginename" = "DuckDuckGo";

    # Profile name
    "zen.profile.name" = config.home.username;

    # Session restore - preserves pinned tabs and workspaces
    "browser.startup.page" = 3; # Restore previous session
    "browser.sessionstore.resume_from_crash" = true;
    "browser.sessionstore.resume_session_once" = false;

    # Zen Browser specific
    "zen.view.compact" = true; # Enable compact mode
    "zen.view.compact.enable-at-startup" = true;
    "zen.view.compact.hide-tabbar" = true;
    "zen.view.compact.hide-toolbar" = true;
    "zen.view.use-single-toolbar" = false;
    "zen.welcome-screen.seen" = true;
    "zen.ui.migration.compact-mode-button-added" = true;
    "browser.toolbars.bookmarks.visibility" = "always"; # Show bookmarks bar
  };

  extensions = [
    # To add additional extensions, find it on addons.mozilla.org, find
    # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
    (extension "darkreader" "addon@darkreader.org" true)
    (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me" true)
    (extension "addon/proton-vpn-firefox-extension" "vpn@proton.ch" false)
    (extension "firefox-color" "FirefoxColor@mozilla.com" false)
    (extension "gnome-shell-integration" "chrome-gnome-shell@gnome.org" false)
    # ...
  ];
in {
  home.packages = [
    (
      pkgs.wrapFirefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
      {
        extraPrefs = lib.concatLines (
          lib.mapAttrsToList (
            name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});''
          )
          browserPrefs
        );

        extraPolicies = {
          # Updates & Background Services
          AppAutoUpdate = false;
          BackgroundAppUpdate = false;

          DisableTelemetry = true;
          ExtensionSettings = builtins.listToAttrs extensions;

          SearchEngines = {
            Default = "ddg";
            Add = [
              {
                Name = "nixpkgs packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@np";
              }
              {
                Name = "NixOS options";
                URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@no";
              }
              {
                Name = "NixOS Wiki";
                URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@nw";
              }
              {
                Name = "noogle";
                URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                IconURL = "https://noogle.dev/favicon.ico";
                Alias = "@ng";
              }
            ];
          };
        };
      }
    )
  ];
}
