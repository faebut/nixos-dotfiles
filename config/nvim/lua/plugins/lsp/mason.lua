return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls", -- typescript
        "html", -- html
        "cssls", -- css
        "tailwindcss", -- tailwind
        "vtsls", -- vue
        "svelte", -- svelte
        "lua_ls", -- lua
        "graphql", -- graphql
        "emmet_ls",
        "pyright",
        "eslint", -- linter
        "gopls", -- golang
        "templ", -- go templ
        "jsonls", -- json
        "rust_analyzer", -- rust
        "bashls", --bash
        "jsonls", --json
        "yamlls", --yaml
        "docker_language_server", -- dockerfiles
        "docker_compose_language_service", -- docker compose
        "htmx", -- htmx
        "marksman", -- markdown
        "postgres_lsp", -- PostgresQL
        -- "sqlls", -- sql, not sure if better than above
        "nil_ls", -- nix expression 
      },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "eslint_d",
        "rustfmt", -- rust formatter
        "alejandra", -- nix formatter
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
