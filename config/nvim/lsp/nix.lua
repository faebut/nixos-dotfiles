---@type vim.lsp.Config
return {
  cmd = { "nixd" },
  filetypes = { "nix" },
  settings = {
    nixpkgs = {
      -- For flake.
      -- This expression will be interpreted as "nixpkgs" toplevel
      -- Nixd provides package, lib completion/information from it.
      -- Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
      -- Package documentation, versions, are evaluated by-need.
      expr = "import (builtins.getFlake(toString ./.)).inputs.nixpkgs { }",
    },
    formatting = {
      command = { "nixfmt" },
    },
    options = {
      nixos = {
        expr = "let flake = builtins.getFlake(toString ./.); in flake.nixosConfigurations.nixpad1.options",
      },
      -- home_manager = {
      --   expr = 'let flake = builtins.getFlake(toString ./.); in flake.homeConfigurations."faebut@nixpad1".options',
      -- },
    },
  },
}
