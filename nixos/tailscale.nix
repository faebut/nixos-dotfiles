{
  config,
  pkgs,
  ...
}: {
  # Declare Tailscale secrets
  sops.secrets."tailscale.auth-key" = {
    key = "tailscale/auth-key";
    mode = "0400";
    owner = "root";
    group = "root";
  };

  sops.secrets."tailscale.server-url" = {
    key = "tailscale/server-url";
    mode = "0400";
    owner = "root";
    group = "root";
  };

  # Enable Tailscale service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    authKeyFile = config.sops.secrets."tailscale.auth-key".path;
  };

  # Configure Tailscale to use Headscale server
  # The extraUpFlags needs the actual URL, so we use a systemd override
  systemd.services.tailscaled.serviceConfig = {
    Environment = [
      "TS_AUTHKEY_FILE=${config.sops.secrets."tailscale.auth-key".path}"
    ];
  };

  # Create script to connect with headscale server URL from secrets
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale/Headscale";
    after = ["network-pre.target" "tailscaled.service"];
    wants = ["network-pre.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Wait for tailscaled to be ready
      sleep 2
      
      # Check if already connected
      status=$(${pkgs.tailscale}/bin/tailscale status --json 2>/dev/null || echo "{}")
      
      if echo "$status" | ${pkgs.jq}/bin/jq -e '.BackendState == "Running"' >/dev/null 2>&1; then
        echo "Tailscale is already connected"
        exit 0
      fi
      
      # Read server URL from secrets
      SERVER_URL=$(cat ${config.sops.secrets."tailscale.server-url".path})
      AUTH_KEY=$(cat ${config.sops.secrets."tailscale.auth-key".path})
      
      # Connect to Headscale
      ${pkgs.tailscale}/bin/tailscale up \
        --login-server="$SERVER_URL" \
        --authkey="$AUTH_KEY" \
        --accept-routes
    '';
  };

  # Open firewall for Tailscale
  networking.firewall.trustedInterfaces = ["tailscale0"];
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];
}
