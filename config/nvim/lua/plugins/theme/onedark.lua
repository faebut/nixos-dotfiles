-- Using Lazy
return {
  "navarasu/onedark.nvim",
  name = "onedark",
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('onedark').setup {
      style = 'darker' -- or try 'warmer' for similar darkness but warmer tone
    }
    require('onedark').load()
  end
}
