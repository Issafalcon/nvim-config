local opts = {
  cmd = {"emmet-language-server", "--stdio"},
  filetypes = {
    "html",
    "typescriptreact",
    "javascriptreact",
    "javascript",
    "typescript",
    "javascript.jsx",
    "typescript.tsx",
    "css"
  },
  root_dir = function(fname)
    return vim.loop.cwd()
  end,
  settings = {}
}

return opts
