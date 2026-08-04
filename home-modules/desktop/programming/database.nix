{
  pkgs,
  unstablePkgs,
  ...
}: let
  luna-modeler = pkgs.appimageTools.wrapType2 {
    pname = "luna-modeler";
    version = "14.0.0";
    src = pkgs.fetchurl {
      url = "https://www.datensen.com/downloads/Luna%20Modeler-14.0.0-x86_64.AppImage";
      name = "luna-modeler-14.0.0.AppImage";
      hash = "sha256-kYGw3AKzyR6HngHA6i9apR+EnCOMXzL9iFTvwEovGGg=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        # Add any additional dependencies if needed
      ];
    extraInstallCommands = let
      contents = pkgs.appimageTools.extractType2 {
        pname = "luna-modeler";
        version = "14.0.0";
        src = pkgs.fetchurl {
          url = "https://www.datensen.com/downloads/Luna%20Modeler-14.0.0-x86_64.AppImage";
          name = "luna-modeler-14.0.0.AppImage";
          hash = "sha256-kYGw3AKzyR6HngHA6i9apR+EnCOMXzL9iFTvwEovGGg=";
        };
      };
    in ''
      install -Dm444 ${contents}/luna.desktop $out/share/applications/luna-modeler.desktop
      substituteInPlace $out/share/applications/luna-modeler.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${placeholder "out"}/bin/luna-modeler' \
        --replace-fail 'Icon=luna' 'Icon=luna-modeler'
      install -Dm444 ${contents}/luna.png \
        $out/share/icons/hicolor/512x512/apps/luna-modeler.png
    '';
  };
in {
  home.packages = with pkgs;
    [
      pgmodeler # TODO: we have subscription, this is the free version
      luna-modeler
    ]
    ++ (with unstablePkgs; [
      beekeeper-studio # db viewer
    ]);
}
