-- Add lsp servers from local setup (i.e. Not installed as per nvim-lsp-installer
local servers = {}

local opts = {
  on_attach = require("lsp.handlers").on_attach,
  capabilities = require("lsp.handlers").capabilities
}

-- Emmet-ls main repo doesn't support jsx or tsx: https://github.com/aca/emmet-ls/issues/10
-- Until this is fixed install the alternative repo using lsp-config: https://github.com/kozer/emmet-language-server
servers.emmet_ls = require("lsp.settings.emmet-ls")

for server, config in pairs(servers) do
  require("lspconfig")[server].setup(vim.tbl_deep_extend("force", config, opts))
end
