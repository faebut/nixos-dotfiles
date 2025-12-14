---@type vim.lsp.Config
return {
  cmd = { "templ", "lsp" },
  filetypes = { "templ" },
  settings = {
    formatting = {
      command = { "templ", "fmt" },
    },
  },
}
