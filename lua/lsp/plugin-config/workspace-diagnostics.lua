---@type FigNvimPluginConfig
local M = {}

-- Currently unused as it breaks roslyn server
M.lazy_config = function()
  vim.api.nvim_set_keymap("n", "<space>X", "", {
    noremap = true,
    callback = function()
      for _, client in ipairs(vim.lsp.buf_get_clients()) do
        require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
      end
    end,
  })
  fignvim.lsp.on_attach(require("workspace-diagnostics").populate_workspace_diagnostics)
end

return M
