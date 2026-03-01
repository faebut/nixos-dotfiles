-- LSP activation (references lsp/<filename>

-- configure sqls - finds config.yml in project root
vim.lsp.config("sqls", {
	filetypes = { "sql", "mysql" },
	root_markers = { "config.yml", ".git" },
	cmd = function(dispatchers, config)
		local cmd_args = { "sqls" }
		if config.root_dir then
			local cfg = config.root_dir .. "/config.yml"
			if vim.uv.fs_stat(cfg) then
				cmd_args = { "sqls", "-config", cfg }
			end
		end
		return vim.lsp.rpc.start(cmd_args, dispatchers, {
			cwd = config.root_dir,
		})
	end,
})

-- enable manually installed lsp
vim.lsp.enable({
	"templ",
	"lua_ls",
	"nixd",
	"marksman",
	"sqls",
	"htmx",
	"gopls",
})

-- Themes:
vim.cmd.colorscheme("catppuccin")
-- vim.opt.background = "light" -- light, dark
