{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: [
      (epkgs.treesit-grammars.with-grammars (p: [
        p.tree-sitter-go
        p.tree-sitter-gomod
        p.tree-sitter-html
        p.tree-sitter-javascript
        p.tree-sitter-typescript
        p.tree-sitter-css
        p.tree-sitter-python
        p.tree-sitter-rust
        p.tree-sitter-lua
        p.tree-sitter-bash
        p.tree-sitter-nix
        p.tree-sitter-yaml
        p.tree-sitter-json
        p.tree-sitter-templ
      ]))
    ];
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
    dockerfile-language-server
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
