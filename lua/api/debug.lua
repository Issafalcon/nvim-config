fignvim.debug = {}

local function check_and_close_existing_session(dap)
  if dap.session() then
    dap.terminate()
    dap.close()
  end
end

function fignvim.debug.setup_debug_configs()
  local dap = fignvim.plug.load_module_file("dap", true)
  local config = require("user-configs.dap")

  for language, dap_settings in pairs(config) do
    dap.configurations[language] = dap_settings
  end
end
return fignvim.debug
