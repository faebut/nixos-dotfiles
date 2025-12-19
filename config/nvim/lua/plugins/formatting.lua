return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt" }, 
        go = { "gofumpt", "goimports_reviser" }, 
        nix = { "alejandra" },
      },
      format_on_save = function(bufnr)
        -- Disable LSP fallback for Nix files to avoid error message
        if vim.bo[bufnr].filetype == "nix" then
          return {
            lsp_fallback = false,
            timeout_ms = 3000,
          }
        end
        return {
          lsp_fallback = true,
          async = false,
          timeout_ms = 3000,
        }
      end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local format_opts = {
        async = false,
        timeout_ms = 1000,
      }
      
      -- Disable LSP fallback for Nix files
      if vim.bo[bufnr].filetype == "nix" then
        format_opts.lsp_fallback = false
      else
        format_opts.lsp_fallback = true
      end
      
      conform.format(format_opts)
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
