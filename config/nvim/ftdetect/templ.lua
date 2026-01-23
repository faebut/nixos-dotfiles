vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

-- Register treesitter parser for templ filetype
vim.treesitter.language.register('templ', 'templ')
