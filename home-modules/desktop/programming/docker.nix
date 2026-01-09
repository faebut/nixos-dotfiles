{pkgs, ...}: {
  home.packages = with pkgs; [
    docker-compose
    docker-buildx
    lazydocker # TUI for docker management (like lazygit)
  ];

  # Session variables are set automatically by virtualisation.docker.rootless.setSocketVariable
  home.sessionVariables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
  };
}
