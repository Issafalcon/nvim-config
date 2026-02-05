return {
  cmd = { "emmet-ls", "--stdio" },
  filetypes = {
    "html",
    "typescriptreact",
    "javascriptreact",
    "javascript",
    "typescript",
    "javascript.jsx",
    "typescript.tsx",
    "css",
  },
  -- root_dir = function(_)
  --   return vim.loop.cwd()
  -- end,
  settings = {},
}
