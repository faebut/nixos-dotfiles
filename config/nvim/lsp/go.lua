---@type vim.lsp.Config
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.work", ".git" },
  telemetry = { enabled = false },
  settings = {
    env = {
      GOEXPERIMENT = "rangefunc",
    },
    formatting = {
      gofumpt = true,
    },
  },
}
