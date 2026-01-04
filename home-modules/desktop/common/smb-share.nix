{
  config,
  pkgs,
  ...
}: {
  # Declare SMB secrets at home-manager level
  sops.secrets."smb.server" = {
    key = "smb/server";
  };

  sops.secrets."smb.share" = {
    key = "smb/share";
  };

  sops.secrets."smb.username" = {
    key = "smb/username";
  };

  sops.secrets."smb.password" = {
    key = "smb/password";
  };

  # User service to store SMB credentials in GNOME Keyring (runs once)
  systemd.user.services.gvfs-smb-credentials = {
    Unit = {
      Description = "Store SMB credentials in GNOME Keyring";
      After = [ "graphical-session.target" "gnome-keyring-daemon.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "store-smb-credentials" ''
        # Read secrets
        SERVER=$(cat ${config.sops.secrets."smb.server".path})
        SHARE=$(cat ${config.sops.secrets."smb.share".path})
        USERNAME=$(cat ${config.sops.secrets."smb.username".path})
        PASSWORD=$(cat ${config.sops.secrets."smb.password".path})
        
        # Store credentials in GNOME Keyring with the correct GVFS schema
        # GVFS uses org.gnome.keyring.NetworkPassword schema
        echo -n "$PASSWORD" | ${pkgs.libsecret}/bin/secret-tool store \
          --label="Network password for smb://$SERVER/$SHARE" \
          xdg:schema org.gnome.keyring.NetworkPassword \
          server "$SERVER" \
          object "$SHARE" \
          user "$USERNAME" \
          protocol smb
        
        # Create/update bookmark dynamically
        mkdir -p ~/.config/gtk-3.0
        
        # Start with base bookmarks if they exist
        if [ -f ~/.config/gtk-3.0/bookmarks-base ]; then
          cp ~/.config/gtk-3.0/bookmarks-base ~/.config/gtk-3.0/bookmarks
        else
          # Fallback if bookmarks-base doesn't exist
          echo "" > ~/.config/gtk-3.0/bookmarks
        fi
        
        # Append SMB share bookmark
        echo "smb://$SERVER/$SHARE Prozessor Share" >> ~/.config/gtk-3.0/bookmarks
      '';
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
