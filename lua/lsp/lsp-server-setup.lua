-- Add lsp servers from local setup (i.e. Not installed as per nvim-lsp-installer
local servers = {
  jsonls = require("lsp.settings.jsonls"),
  cucumber_language_server = require("lsp.settings.cucumberls"),
  tsserver = require("lsp.settings.tsserver"),
  sumneko_lua = require("lsp.settings.sumneko_lua"),
  texlab = require("lsp.settings.texlab"),
  omnisharp = require("lsp.settings.omnisharp"),
  terraformls = require("lsp.settings.terraformls"),
  stylelint_lsp = require("lsp.settings.stylelint_lsp"),
  emmet_ls = require("lsp.settings.emmet-ls"),
  bashls = {},
  dockerls = {},
  html = {},
  vimls = {},
  yamlls = require("lsp.settings.yamlls"),
  angularls = {},
  cssls = {},
  tflint = {},
  sqls = {}
}

local opts = {
  on_attach = require("lsp.handlers").on_attach,
  capabilities = require("lsp.handlers").capabilities
}

for server, config in pairs(servers) do
  local setup_opts = vim.tbl_deep_extend("force", config, opts)

  if server == "sumneko_lua" then
    -- For developing Lua plugins for Neovim Only
    -- Comment out below lines so lua_dev is not used when working on other Lua projects
    setup_opts = require("lua-dev").setup({
      library = { vimruntime = true, types = true, plugins = true },
      lspconfig = opts,
    })
  end

  require("lspconfig")[server].setup(setup_opts)
end
