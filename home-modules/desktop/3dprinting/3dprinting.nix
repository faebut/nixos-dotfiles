{pkgs, ...}: let
  lycheeslicer-fixed = pkgs.symlinkJoin {
    name = "lycheeslicer-fixed";
    paths = [
      (pkgs.runCommand "lycheeslicer-desktop-fix" {} ''
        mkdir -p "$out/share/applications"
        find ${pkgs.lycheeslicer}/share/applications -name "*.desktop" | while read -r f; do
          sed 's/Exec=lychee/Exec=LycheeSlicer/g' "$f" > "$out/share/applications/$(basename "$f")"
        done
      '')
      pkgs.lycheeslicer
    ];
  };
in {
  # CHITUBOX Basic: install via Flatpak (not in nixpkgs, binary installer too complex to wrap)
  # flatpak install flathub com.chitubox.ChituBox
  home.packages = [
    pkgs.orca-slicer
    lycheeslicer-fixed
  ];
}
