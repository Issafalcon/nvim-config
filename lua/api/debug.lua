fignvim.debug = {}

function fignvim.debug.setup_debug_configs()
  local dap_ok, dap = pcall(require, "dap")
  local config = require("modules.debugging.dap_configs")

  if dap_ok then
    for language, dap_settings in pairs(config) do
      dap.configurations[language] = dap_settings
    end
  end
end

return fignvim.debug
