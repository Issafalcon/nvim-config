-- Nvim-lsp-installer setup to add hooks to the native lsp-config setup functions
require("nvim-lsp-installer").setup {}

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
  bashls = {},
  dockerls = {},
  html = {},
  vimls = {},
  yamlls = {},
  angularls = {},
  cssls = {},
  tflint = {}
}

local opts = {
  on_attach = require("lsp.handlers").on_attach,
  capabilities = require("lsp.handlers").capabilities
}

-- Emmet-ls main repo doesn't support jsx or tsx: https://github.com/aca/emmet-ls/issues/10
-- Until this is fixed install the alternative repo using lsp-config: https://github.com/kozer/emmet-language-server
servers.emmet_ls = require("lsp.settings.emmet-ls")

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
