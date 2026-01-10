{pkgs, ...}: {
  home.packages = with pkgs; [
    docker-compose
    docker-buildx
    lazydocker # TUI for docker management (like lazygit)
  ];

  # Set DOCKER_HOST for rootless docker
  home.sessionVariables = {
    DOCKER_HOST = "unix:///run/user/1000/docker.sock";
  };
}
