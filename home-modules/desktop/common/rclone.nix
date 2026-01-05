# rclone configuration for OneDrive
{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}: {
  home.packages = with pkgs; [
    rclone
  ];

  # Create rclone config directory
  home.file.".config/rclone/.keep".text = "";

  # Systemd service to mount OneDrive (based on working rclone@.service pattern)
  systemd.user.services.onedrive-mount = lib.mkIf (osConfig.sops.secrets ? "rclone/onedrive-business/token") {
    Unit = {
      Description = "RClone mount of OneDrive Business";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
    };

    Service = {
      Type = "simple";
      
      # Pre-flight checks and config generation
      ExecStartPre = pkgs.writeShellScript "onedrive-mount-pre" ''
        # Read values from SOPS secrets
        TOKEN=$(cat ${osConfig.sops.secrets."rclone/onedrive-business/token".path})
        DRIVE_ID=$(cat ${osConfig.sops.secrets."rclone/onedrive-business/drive-id".path})
        DRIVE_NAME=$(cat ${osConfig.sops.secrets."rclone/onedrive-business/drive-name".path})
        
        # Create rclone config
        mkdir -p "$HOME/.config/rclone"
        cat > "$HOME/.config/rclone/rclone.conf" <<EOF
[onedrive-business]
type = onedrive
token = $TOKEN
drive_id = $DRIVE_ID
drive_type = business
delta = true
EOF
        
        # Create mount point
        mkdir -p "$HOME/Cloud/$DRIVE_NAME"
        
        # Ensure mount directory is empty
        if [ "$(ls -A "$HOME/Cloud/$DRIVE_NAME" 2>/dev/null)" ]; then
          ${pkgs.util-linux}/bin/fusermount -u "$HOME/Cloud/$DRIVE_NAME" 2>/dev/null || true
        fi
      '';
      
      # Mount with settings from the working service
      ExecStart = pkgs.writeShellScript "onedrive-mount-start" ''
        DRIVE_NAME=$(cat ${osConfig.sops.secrets."rclone/onedrive-business/drive-name".path})
        exec ${pkgs.rclone}/bin/rclone mount \
          --config="$HOME/.config/rclone/rclone.conf" \
          --allow-other \
          --default-permissions \
          --vfs-cache-mode=full \
          --vfs-cache-max-age=72h \
          --vfs-cache-max-size=50G \
          --dir-cache-time=60m \
          --poll-interval=15s \
          --vfs-read-chunk-size=32M \
          onedrive-business: "$HOME/Cloud/$DRIVE_NAME"
      '';
      
      # Unmount
      ExecStop = pkgs.writeShellScript "onedrive-mount-stop" ''
        DRIVE_NAME=$(cat ${osConfig.sops.secrets."rclone/onedrive-business/drive-name".path})
        ${pkgs.util-linux}/bin/fusermount -u "$HOME/Cloud/$DRIVE_NAME"
      '';
      
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };

  # Systemd service to mount STAO shared folder
  systemd.user.services.onedrive-stao-mount = lib.mkIf (osConfig.sops.secrets ? "rclone/onedrive-business/token") {
    Unit = {
      Description = "RClone mount of OneDrive Business STAO shared folder";
      After = ["network-online.target" "onedrive-mount.service"];
      Wants = ["network-online.target"];
      Requires = ["onedrive-mount.service"];
    };

    Service = {
      Type = "simple";
      
      # Pre-flight checks
      ExecStartPre = pkgs.writeShellScript "onedrive-stao-mount-pre" ''
        # Create mount point
        mkdir -p "$HOME/Cloud/STAO"
        
        # Ensure mount directory is empty
        if [ "$(ls -A "$HOME/Cloud/STAO" 2>/dev/null)" ]; then
          ${pkgs.util-linux}/bin/fusermount -u "$HOME/Cloud/STAO" 2>/dev/null || true
        fi
      '';
      
      # Mount STAO shared folder
      ExecStart = pkgs.writeShellScript "onedrive-stao-mount-start" ''
        exec ${pkgs.rclone}/bin/rclone mount \
          --config="$HOME/.config/rclone/rclone.conf" \
          --allow-other \
          --default-permissions \
          --vfs-cache-mode=full \
          --vfs-cache-max-age=72h \
          --vfs-cache-max-size=50G \
          --dir-cache-time=60m \
          --poll-interval=15s \
          --vfs-read-chunk-size=32M \
          onedrive-business:STAO "$HOME/Cloud/STAO"
      '';
      
      # Unmount
      ExecStop = pkgs.writeShellScript "onedrive-stao-mount-stop" ''
        ${pkgs.util-linux}/bin/fusermount -u "$HOME/Cloud/STAO"
      '';
      
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };

  # Systemd service to mount Grundkompetenzen shared folder
  systemd.user.services.onedrive-grundkompetenzen-mount = lib.mkIf (osConfig.sops.secrets ? "rclone/onedrive-business/token") {
    Unit = {
      Description = "RClone mount of OneDrive Business Grundkompetenzen shared folder";
      After = ["network-online.target" "onedrive-mount.service"];
      Wants = ["network-online.target"];
      Requires = ["onedrive-mount.service"];
    };

    Service = {
      Type = "simple";
      
      # Pre-flight checks
      ExecStartPre = pkgs.writeShellScript "onedrive-grundkompetenzen-mount-pre" ''
        # Create mount point
        mkdir -p "$HOME/Cloud/Grundkompetenzen"
        
        # Ensure mount directory is empty
        if [ "$(ls -A "$HOME/Cloud/Grundkompetenzen" 2>/dev/null)" ]; then
          ${pkgs.util-linux}/bin/fusermount -u "$HOME/Cloud/Grundkompetenzen" 2>/dev/null || true
        fi
      '';
      
      # Mount Grundkompetenzen shared folder
      ExecStart = pkgs.writeShellScript "onedrive-grundkompetenzen-mount-start" ''
        exec ${pkgs.rclone}/bin/rclone mount \
          --config="$HOME/.config/rclone/rclone.conf" \
          --allow-other \
          --default-permissions \
          --vfs-cache-mode=full \
          --vfs-cache-max-age=72h \
          --vfs-cache-max-size=50G \
          --dir-cache-time=60m \
          --poll-interval=15s \
          --vfs-read-chunk-size=32M \
          onedrive-business:Grundkompetenzen "$HOME/Cloud/Grundkompetenzen"
      '';
      
      # Unmount
      ExecStop = pkgs.writeShellScript "onedrive-grundkompetenzen-mount-stop" ''
        ${pkgs.util-linux}/bin/fusermount -u "$HOME/Cloud/Grundkompetenzen"
      '';
      
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
