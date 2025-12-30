{pkgs, ...}: let
  luna-modeler = pkgs.appimageTools.wrapType2 {
    pname = "luna-modeler";
    version = "12.3.0";
    src = pkgs.fetchurl {
      url = "https://www.datensen.com/downloads/Luna%20Modeler-12.3.0-x86_64.AppImage";
      hash = "sha256-DF2E0C9E1Qlw2bAZ1UWu0cLISc4ECGU5g7Kpn2c74Uc=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        # Add any additional dependencies if needed
      ];
    extraInstallCommands = let
      contents = pkgs.appimageTools.extractType2 {
        pname = "luna-modeler";
        version = "12.3.0";
        src = pkgs.fetchurl {
          url = "https://www.datensen.com/downloads/Luna%20Modeler-12.3.0-x86_64.AppImage";
          hash = "sha256-DF2E0C9E1Qlw2bAZ1UWu0cLISc4ECGU5g7Kpn2c74Uc=";
        };
      };
    in ''
      install -Dm444 ${contents}/modeler.desktop $out/share/applications/luna-modeler.desktop
      substituteInPlace $out/share/applications/luna-modeler.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${placeholder "out"}/bin/luna-modeler' \
        --replace-fail 'Icon=modeler' 'Icon=luna-modeler'
      install -Dm444 ${contents}/usr/share/icons/hicolor/512x512/apps/modeler.png \
        $out/share/icons/hicolor/512x512/apps/luna-modeler.png
    '';
  };
in {
  home.packages = with pkgs; [
    pgmodeler # TODO: we have subscription, this is the free version
    luna-modeler

    beekeeper-studio # db viewer
  ];
}
