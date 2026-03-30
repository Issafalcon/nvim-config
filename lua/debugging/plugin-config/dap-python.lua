local dap_config = require("debugging.plugin-config.dap")

---@type FigNvimPluginConfig
local M = {}

M.lazy_config = function()
  local path = dap_config.dap_install_dir .. "/packages/debugpy/venv/bin/python"
  require("dap-python").setup(path)
end

return M
