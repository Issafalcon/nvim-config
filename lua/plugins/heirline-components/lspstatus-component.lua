local surrounds = require("plugins.heirline-components.surrounds")

local LSPMessages = {
  hl = { fg = "lsp_status_fg", bg = "component_bg" },

  update = {
    "User",
    pattern = "LspProgressStatusUpdated",
    callback = function()
      vim.schedule(function()
        vim.cmd("redrawstatus")
      end)
    end,
  },

  surrounds.RightSlantStart,
  {
    provider = function()
      local result = require("lsp-progress").progress({
        max_size = math.max(math.floor(vim.o.columns / 2) - 5, 3),
      })
      if result ~= "" then
        return " " .. result
      end
      return ""
    end,
  },
  surrounds.RightSlantEnd,
}

return LSPMessages
