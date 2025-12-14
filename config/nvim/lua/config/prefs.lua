-- LSP activation (references lsp/<filename>
vim.lsp.enable({
  "lua",
  "nix",
  "go",
  "css",
  "html",
  "htmx",
  "json",
  "tailwindcss",
  "templ",
})

vim.opt.termguicolors = true
-- Themes:
vim.cmd.colorscheme("catppuccin")
-- vim.opt.background = "light" -- light, dark
