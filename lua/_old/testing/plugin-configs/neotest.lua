---@diagnostic disable: missing-fields
---@type FigNvimPluginConfig
local M = {}

M.lazy_config = function()
  local neotest = require("neotest")
  neotest.setup({
    log_level = 1, -- For verbose logs
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
      }),
      require("neotest-plenary"),
      require("neotest-dotnet")({
        discovery_root = "solution",
      }),
      require("neotest-jest")({
        jestCommand = "npm test -- --runInBand --no-cache --watchAll=false",
        env = { CI = "true" },
        cwd = function(_)
          return vim.fn.getcwd()
        end,
      }),
    },
  })
end

return M
