fignvim.debug = {}

local function check_and_close_existing_session(dap)
  if dap.session() then
    dap.terminate()
    dap.close()
  end
end

function fignvim.debug.setup_debug_configs()
  local dap_ok, dap = pcall(require, "dap")
  local config = require("modules.debugging.dapconfig")

  for language, dap_settings in pairs(config) do
    dap.configurations[language] = dap_settings
  end
end
return fignvim.debug
