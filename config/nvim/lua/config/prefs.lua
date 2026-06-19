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

-- Restart all LSP clients attached to the current buffer
vim.api.nvim_create_user_command("LspRestart", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, client in ipairs(clients) do
		local bufs = vim.lsp.get_buffers_by_client_id(client.id)
		client:stop()
		vim.defer_fn(function()
			for _, buf in ipairs(bufs) do
				if vim.api.nvim_buf_is_valid(buf) then
					vim.lsp.start(client.config, { bufnr = buf })
				end
			end
		end, 500)
	end
end, { desc = "Restart LSP clients for current buffer" })

-- Themes:
vim.cmd.colorscheme("catppuccin")
-- vim.opt.background = "light" -- light, dark
