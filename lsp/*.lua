-- ~/.config/nvim/lsp/global.lua
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Add capabilities required for LSP based completions
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end

return {
  capabilities = capabilities,
}
