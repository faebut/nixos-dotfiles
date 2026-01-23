-- LSP activation (references lsp/<filename>
-- enable manually installed lsp
vim.lsp.enable({
	"lua_ls",
	"nixd",
	"marksman",
	"postgres_lsp",
	"htmx-lsp",
	"templ",
	-- "go",
	-- "css",
	-- "html",
	-- "htmx",
	-- "json",
	-- "tailwindcss",
})

-- Themes:
vim.cmd.colorscheme("catppuccin")
-- vim.opt.background = "light" -- light, dark
