{ ... }:

{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "codeberg" = {
        host = "codeberg.org";
        identitiesOnly = true;
        identityFile = [
          "~/.ssh/id_faebut"
        ];
      };
    };
  };
}
