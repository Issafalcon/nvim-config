---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
}

return M
