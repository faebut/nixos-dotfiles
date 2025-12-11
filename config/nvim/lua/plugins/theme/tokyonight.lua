return {
    "folke/tokyonight.nvim",
    tag = "stable",
    lazy = false,
    enabled = false,
    priority = 1000,
    opts = {},
    config = function()
        local tokyonight = require("tokyonight")
        local util = require("tokyonight.util")
        tokyonight.setup({
            styles = {
                -- See :help nvim_set_hl
                comments = { italic = true },
                --functions = { underdotted = true },
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

                -- Remove borders from Telescope windows
                local prompt = "#2d3149"
                hl.TelescopeNormal = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.TelescopeBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopePromptNormal = {
                    bg = prompt,
                }
                hl.TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePromptTitle = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopeResultsTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
            end,
        })
    end,
}
