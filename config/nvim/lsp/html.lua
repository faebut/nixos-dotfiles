---@type vim.lsp.Config
return {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html", "templ" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    html = {
      format = { enable = true },
    },
  },
}
