{
  config,
  pkgs,
  lib,
  ...
}: {
  # Declare SMB secrets at home-manager level
  sops.secrets."si-smb.server" = {
    key = "si-smb/server";
  };

  sops.secrets."si-smb.username" = {
    key = "si-smb/username";
  };

  sops.secrets."si-smb.password" = {
    key = "si-smb/password";
  };

  sops.secrets."si-smb.share1" = {
    key = "si-smb/share1";
  };

  sops.secrets."si-smb.share1-name" = {
    key = "si-smb/share1-name";
  };

  sops.secrets."si-smb.share2" = {
    key = "si-smb/share2";
  };

  sops.secrets."si-smb.share2-name" = {
    key = "si-smb/share2-name";
  };

  sops.secrets."si-smb.share3" = {
    key = "si-smb/share3";
  };

  sops.secrets."si-smb.share3-name" = {
    key = "si-smb/share3-name";
  };

  # User service to store SMB credentials in GNOME Keyring
  systemd.user.services.gvfs-smb-si-credentials = {
    Unit = {
      Description = "Store SMB SI credentials in GNOME Keyring";
      After = [ "graphical-session.target" "gnome-keyring-daemon.service" "gvfs-smb-credentials.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "store-smb-si-credentials" ''
        # Read secrets
        SERVER=$(cat ${config.sops.secrets."si-smb.server".path})
        USERNAME=$(cat ${config.sops.secrets."si-smb.username".path})
        PASSWORD=$(cat ${config.sops.secrets."si-smb.password".path})
        
        SHARE1=$(cat ${config.sops.secrets."si-smb.share1".path})
        SHARE1_NAME=$(cat ${config.sops.secrets."si-smb.share1-name".path})
        
        SHARE2=$(cat ${config.sops.secrets."si-smb.share2".path})
        SHARE2_NAME=$(cat ${config.sops.secrets."si-smb.share2-name".path})
        
        SHARE3=$(cat ${config.sops.secrets."si-smb.share3".path})
        SHARE3_NAME=$(cat ${config.sops.secrets."si-smb.share3-name".path})
        
        # Store credentials for each share in GNOME Keyring
        for SHARE in "$SHARE1" "$SHARE2" "$SHARE3"; do
          echo -n "$PASSWORD" | ${pkgs.libsecret}/bin/secret-tool store \
            --label="Network password for smb://$SERVER/$SHARE" \
            xdg:schema org.gnome.keyring.NetworkPassword \
            server "$SERVER" \
            object "$SHARE" \
            user "$USERNAME" \
            protocol smb
        done
        
        # Append SI SMB share bookmarks (don't overwrite, just append)
        mkdir -p ~/.config/gtk-3.0
        
        # Ensure bookmarks file exists
        touch ~/.config/gtk-3.0/bookmarks
        
        # Remove old SI bookmarks if they exist (from this specific server)
        grep -v "smb://$SERVER/" ~/.config/gtk-3.0/bookmarks > ~/.config/gtk-3.0/bookmarks.tmp 2>/dev/null || touch ~/.config/gtk-3.0/bookmarks.tmp
        mv ~/.config/gtk-3.0/bookmarks.tmp ~/.config/gtk-3.0/bookmarks
        
        # Append new SI SMB share bookmarks
        echo "smb://$SERVER/$SHARE1 $SHARE1_NAME" >> ~/.config/gtk-3.0/bookmarks
        echo "smb://$SERVER/$SHARE2 $SHARE2_NAME" >> ~/.config/gtk-3.0/bookmarks
        echo "smb://$SERVER/$SHARE3 $SHARE3_NAME" >> ~/.config/gtk-3.0/bookmarks
      '';
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
