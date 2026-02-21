{pkgs, ...}: let
  gotestdox = pkgs.buildGoModule rec {
    pname = "gotestdox";
    version = "0.2.2";

    src = pkgs.fetchFromGitHub {
      owner = "bitfield";
      repo = "gotestdox";
      rev = "v${version}";
      hash = "sha256-AZDXMwADOjcaMiofMWoHp+eSnD3a8iFtwpWDKl9Ess8=";
    };

    vendorHash = "sha256-kDSZ4RZTHDFmu7ernYRjg0PV7eBB2lH8q5wW3kTExDs=";

    meta = with pkgs.lib; {
      description = "tool for formatting Go test results as readable documentation";
      homepage = "https://github.com/bitfield/gotestdox";
      license = licenses.mit;
      mainProgram = "gotestdox";
    };
  };
in {
  home.packages = [
    gotestdox
  ];
}
