return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- Install parsers (do this once, then they persist)
			local parsers = {
				"c", "lua", "vim", "vimdoc", "sql", "json",
				"markdown", "markdown_inline", "javascript", "typescript",
				"html", "templ", "go", "yaml", "toml", "dockerfile",
				"vue", "svelte", "nix", "tsx", "bash", "arduino", "css"
			}
			
			require("nvim-treesitter").install(parsers)
		end,
	},
}
