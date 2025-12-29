{
  pkgs,
  ...
}: {
  # Ensure GVFS and SMB support packages are available
  environment.systemPackages = with pkgs; [
    gvfs
    cifs-utils
  ];
}
