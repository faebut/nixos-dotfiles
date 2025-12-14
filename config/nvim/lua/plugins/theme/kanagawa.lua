return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  branch = "master",
  lazy = false,
  enabled = false,
  priority = 1000,
  opts = {},
  config = function()
    require("kanagawa").setup({
      theme = "lotus",         -- Load "wave" theme
      background = {           -- map the value of 'background' option to a theme
        dark = "wave",         -- try "dragon" !
        light = "lotus",
      },
    })
  end,
}
