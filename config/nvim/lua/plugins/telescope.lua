return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				cond = vim.fn.executable("cmake") == 1,
			},
		},
		opts = function()
			return {
				defaults = {
					vimgrep_arguments = {
						"rg",
						"-L",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					previewer = true,
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
				},
				extensions = {
					file_browser = {
						theme = "ivy",
						hijack_netrw = true,
					},
				},
				extensions_list = {
					-- "file_browser",
				},
			}
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)

			-- load extensions
			for _, ext in ipairs(opts.extensions_list) do
				telescope.load_extension(ext)
			end
		end,
	},
}
