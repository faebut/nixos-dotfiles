-- LSP activation (references lsp/<filename>
-- enable manually installed lsp
vim.lsp.enable({
	"lua_ls",
	"nixd",
	-- "go",
	-- "css",
	-- "html",
	-- "htmx",
	-- "json",
	-- "tailwindcss",
	-- "templ",
})

-- Themes:
vim.cmd.colorscheme("catppuccin")
-- vim.opt.background = "light" -- light, dark
