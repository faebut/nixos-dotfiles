---@type vim.lsp.Config
return {
	cmd = { "templ", "lsp" },
	-- filetypes = { "templ" },
	root_markers = { "go.work", "go.mod", ".git" },
	on_attach = function(client, bufnr)
		-- Enable format on save for templ files
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
		})
	end,
}
