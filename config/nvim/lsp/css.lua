---@type vim.lsp.Config
return {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    css = {
      validate = true,
    },
  },
}
