return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				-- Parser installation configuration
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"sql",
					"json",
					"markdown",
					"markdown_inline",
					"javascript",
					"typescript",
					"html",
					"templ",
					"go",
					"yaml",
					"toml",
					"dockerfile",
					"vue",
					"svelte",
					"nix",
					"tsx",
					"bash",
					"arduino",
					"css",
				},
			})
			
			-- Enable treesitter-based syntax highlighting for buffers with available parsers
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					local buf = args.buf
					local ft = vim.bo[buf].filetype
					
					-- Only try to start treesitter if a parser exists for this filetype
					if ft ~= "" and pcall(vim.treesitter.language.get_lang, ft) then
						local lang = vim.treesitter.language.get_lang(ft)
						if lang and pcall(vim.treesitter.get_parser, buf, lang) then
							vim.treesitter.start(buf, lang)
						end
					end
				end,
			})
		end,
	},
}
