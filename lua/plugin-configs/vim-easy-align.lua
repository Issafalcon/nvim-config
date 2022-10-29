if fignvim.plug.is_available("vim-easy-align") then
  local mappings = require("user-configs.mappings").plugin_mappings["vim-easy-align"]
  fignvim.config.create_mapping_group(mappings, "EasyAlign")
end
