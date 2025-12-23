{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    jdk
  ];

  home.sessionVariables = {
    INSTALL4J_JAVA_HOME = "${pkgs.jdk}";
  };
}
