{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  home.packages = with pkgs; [
    fd
    ripgrep
    coreutils
    git
    shellcheck
    symbola
    nerd-fonts.symbols-only

    # LSP servers
    gopls
    rust-analyzer
    pyright
    typescript-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    svelte-language-server
    lua-language-server
    nil
    nixd
    yaml-language-server
    dockerfile-language-server-nodejs
    docker-compose-language-service
    graphql-language-service-cli
    marksman
    bash-language-server
    emmet-ls

    # Formatters
    gofumpt
    goimports-reviser
    prettier
    black
    isort
    rustfmt
    stylua
    alejandra
    pgformatter
  ];
}
