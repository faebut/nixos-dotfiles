return {
  "rose-pine/neovim",
  name = "rose-pine",
  branch = "main",
  lazy = false,
  enabled = true,
  priority = 1000,
  opts = {},
  config = function()
    local rose = require("rose-pine")
    rose.setup({
      variant = "auto",      -- auto, main, moon, or dawn
      dark_variant = "main", -- main, moon, or dawn
      extend_background_behind_borders = true,
      -- disable_background = true,
      enable = {
        terminal = true,
        legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
        migrations = true,         -- Handle deprecated options automatically
      },
      styles = {
        bold = true,
        transparency = true,
        italic = false,
      },
      highlight_groups = {
        -- Get identifier with `:Inspect` while hovering over word
        Comment = { italic = true },
        -- ["@function"] = { italic = true },
        ["@string.special.url"] = { bold = true },
        -- TelescopeResultsNormal = { fg = "subtle", bg = "none" },

        TelescopeBorder = { fg = "overlay", bg = "overlay" },
        TelescopeNormal = { fg = "subtle", bg = "overlay" },
        TelescopeSelection = { fg = "text", bg = "highlight_med" },
        -- TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
        TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
        TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

        TelescopeTitle = { fg = "base", bg = "love" },
        TelescopePromptTitle = { fg = "base", bg = "pine" },
        TelescopePreviewTitle = { fg = "base", bg = "iris" },

        TelescopePromptNormal = { fg = "text", bg = "surface" },
        TelescopePromptBorder = { fg = "surface", bg = "surface" },
      },
    })
  end,
}
