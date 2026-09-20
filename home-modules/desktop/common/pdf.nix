{pkgs, ...}: {
  home.packages = [
    (pkgs.masterpdfeditor.overrideAttrs (old: {
      version = "5.9.99";
      src = pkgs.fetchurl {
        url = "https://code-industry.net/public/master-pdf-editor-5.9.99-qt5.x86_64-qt_include.tar.gz";
        hash = "sha256-ksVuJyuImstESVwHUmOUv6aERosg6g5bSsRvPSf5EVM=";
      };
      postFixup = (old.postFixup or "") + ''
        substituteInPlace $out/share/applications/net.code-industry.masterpdfeditor5.desktop \
          --replace-fail "Exec=masterpdfeditor5" "Exec=$out/bin/masterpdfeditor5"
      '';
    }))
  ];
}
