{pkgs, unstablePkgs, ...}: let
  lycheeslicer-fixed = pkgs.symlinkJoin {
    name = "lycheeslicer-fixed";
    paths = [
      (pkgs.runCommand "lycheeslicer-desktop-fix" {} ''
        mkdir -p "$out/share/applications"
        find ${unstablePkgs.lycheeslicer}/share/applications -name "*.desktop" | while read -r f; do
          sed 's/Exec=lychee/Exec=LycheeSlicer/g' "$f" > "$out/share/applications/$(basename "$f")"
        done
      '')
      unstablePkgs.lycheeslicer
    ];
  };
in {
  home.packages = [
    pkgs.orca-slicer
    lycheeslicer-fixed
  ];
}
