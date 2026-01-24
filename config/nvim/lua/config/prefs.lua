-- LSP activation (references lsp/<filename>

-- enable manually installed lsp
vim.lsp.enable({
	"templ",
	"lua_ls",
	"nixd",
	"marksman",
	"postgres_lsp",
	"htmx",
	-- "go",
	-- "css",
	-- "html",
	-- "json",
	-- "tailwindcss",
})

-- Themes:
vim.cmd.colorscheme("catppuccin")
-- vim.opt.background = "light" -- light, dark
