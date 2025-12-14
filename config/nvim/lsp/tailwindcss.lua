---@type vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server" },
  filetypes = { "templ", "astro", "javascript", "typescript", "react", "vue" },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        templ = "html",
      },
    },
  },
}
