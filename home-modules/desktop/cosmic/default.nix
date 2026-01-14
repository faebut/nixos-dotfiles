{
  config,
  pkgs,
  osConfig,
  ...
}: {
  imports = [
  ];

  # COSMIC Desktop home-manager configuration
  # Add user-level COSMIC customizations here

  home.packages = with pkgs; [
    # Additional COSMIC tools
  ];
}
