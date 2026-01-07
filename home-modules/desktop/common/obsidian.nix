{
  config,
  pkgs,
  ...
}: {
  programs.obsidian = {
    enable = true;

    # Global settings
    defaultSettings = {
      app = {
        vimMode = true; # Enable vim mode
      };
      appearance = {
        theme = "obsidian"; # Default theme (can change in app)
        baseFontSize = 16;
      };
    };

    # Define vault
    vaults = {
      main = {
        target = "Documents/obsidian-vault"; # Path relative to HOME

        settings = {
          # Core plugins (use default list, all enabled)
          corePlugins = [
            "graph"
            "backlink"
            "outgoing-link"
            "tag-pane"
            "page-preview"
            "daily-notes"
            "templates"
            "note-composer"
            "command-palette"
            "file-explorer"
            "global-search"
            "switcher"
            "outline"
          ];

          # Community plugins - install manually in Obsidian or fetch packages
          # For now, leave empty and enable in app
          communityPlugins = [ ];

          # Vim keybindings via .obsidian.vimrc
          extraFiles = {
            ".obsidian.vimrc" = {
              text = ''
                " Map H to beginning of line (normal and visual mode)
                nmap H ^
                vmap H ^

                " Map L to end of line (normal and visual mode)
                nmap L $
                vmap L $

                " Map jj to escape in insert mode
                imap jj <Esc>
              '';
            };
          };
        };
      };
    };
  };
}
