return {
	"folke/tokyonight.nvim",
	tag = "stable",
	lazy = false,
	enabled = true,
	priority = 1000,
	opts = {},
	config = function()
		local tokyonight = require("tokyonight")
		local util = require("tokyonight.util")
		tokyonight.setup({
			style = "night",
			styles = {
				-- See :help nvim_set_hl
				comments = { italic = true },
				-- functions = {
				-- 	italic = true,
				-- 	bold = true,
				-- },
			},
			on_colors = function(colors)
				-- Brighten up comments a bit
				colors.comment = "#888fac"
				-- Better visible visual selection background color
				--colors.bg_visual = "#e82a86"
				--colors.bg_visual = colors.teal
			end,
			on_highlights = function(hl, c)
				-- Brighter line numbers
				hl.LineNr = {
					fg = util.darken(c.dark5, 0.6),
				}
				--hl.ColorColumn = {
				--	bg = c.purple,
				--}
			end,
		})
	end,
}
