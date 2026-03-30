---@type FigNvimPluginConfig
local M = {}

M.lazy_init = function()
  fignvim.config.set_vim_opts({
    g = {
      copilot_no_tab_map = true, -- Disable tab mapping in insert mode when using copilot (so you can override the default mapping)
      copilot_proxy_strict_ssl = false,
    },
  })
end

return M
