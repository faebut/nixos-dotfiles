-- LSP activation (references lsp/<filename>
vim.lsp.enable({
  "lua",
  "nix",
})

vim.opt.termguicolors = true
-- Themes:
vim.cmd.colorscheme("onedark")
-- vim.opt.background = "light" -- light, dark
