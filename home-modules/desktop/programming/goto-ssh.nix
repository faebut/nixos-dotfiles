{pkgs, ...}: let
  goto-ssh = pkgs.buildGoModule rec {
    pname = "goto";
    version = "1.5.0";

    src = pkgs.fetchFromGitHub {
      owner = "grafviktor";
      repo = "goto";
      rev = "v${version}";
      hash = "sha256-ne9MiZr8er6gUq79HfigokaLUTHZfLOwizDu57Ph2q0=";
    };

    vendorHash = "sha256-ngtjhDzZFOcq7bE6JtA7/xfinfRX2qB0ncE+MCgJTTQ=";

    meta = with pkgs.lib; {
      description = "SSH connection manager with TUI";
      homepage = "https://github.com/grafviktor/goto";
      license = licenses.mit;
      mainProgram = "goto";
    };
  };
in {
  home.packages = [
    goto-ssh
  ];
}
