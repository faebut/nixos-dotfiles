{pkgs, ...}: {
  home.packages = with pkgs; [
    orca-slicer
    (lycheeslicer.overrideAttrs (old: {
      extraInstallCommands =
        (old.extraInstallCommands or "")
        + ''
          substituteInPlace $out/share/applications/*.desktop \
            --replace-fail "Exec=lychee" "Exec=LycheeSlicer"
        '';
    }))
  ];
}
