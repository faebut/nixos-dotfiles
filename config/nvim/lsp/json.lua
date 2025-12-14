---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      validate = { enable = true },
      format = { enable = true },
    },
  },
}
