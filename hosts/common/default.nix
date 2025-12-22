{lib, ...}: {
  imports = [
    ./sops.nix
  ];

  # Custom option for display scaling across different machines
  options.displayScaling = lib.mkOption {
    type = lib.types.str;
    default = "1.0";
    description = "Display scaling factor for this machine";
  };
}
