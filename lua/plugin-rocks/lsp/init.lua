require("plugin-rocks.lsp.mason")
require("plugin-rocks.lsp.mason-lspconfig")
require("plugin-rocks.lsp.mason-tool-installer")
require("plugin-rocks.lsp.none-ls")
require("plugin-rocks.lsp.lazydev")

fignvim.lsp.setup_lsp_servers({
  "jsonls",
  "cucumber_language_server",
  "lua_ls",
  "texlab",
  -- "omnisharp",
  "roslyn.nvim", -- Not directly language server - See https://github.com/jmederosalvarado/roslyn.nvim
  -- "csharp_ls",
  "terraformls",
  "stylelint_lsp",
  "emmet_ls",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "html",
  "vimls",
  "yamlls",
  "angularls",
  "cssls",
  "tflint",
  "powershell_es",
  "eslint",
  "clangd",
  "cmake",
  "pyright",
  "tailwindcss",
  "helm_ls",
  -- "ruff_lsp",
})
