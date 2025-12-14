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
})

vim.opt.termguicolors = true
-- Themes:
vim.cmd.colorscheme("onedark")
-- vim.opt.background = "light" -- light, dark
