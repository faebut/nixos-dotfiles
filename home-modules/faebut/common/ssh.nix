{ ... }:

{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "codeberg" = {
        host = "codeberg.com";
        identitiesOnly = true;
        identityFile = [
          "~/.ssh/id_faebut"
        ];
      };
    };
  };
}
