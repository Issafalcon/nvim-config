local window_picker = fignvim.plug.load_module_file("window-picker")
if not window_picker then
  return
end
local colours = require("user-configs.ui").colours

window_picker.setup({ use_winbar = "smart", other_win_hl_color = colours.grey_4 })
