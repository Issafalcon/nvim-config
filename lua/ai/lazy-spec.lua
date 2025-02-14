--- @type FigNvimPluginConfig
local copilot = require("ai.plugin-config.copilot")

return {
  {
    -- https://github.com/zbirenbaum/copilot.lua
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = copilot.lazy_opts,
  },
}
