local conditions = require("heirline.conditions")

local LSPMessages = {
  hl = { fg = "lsp_status_fg", bg = "component_bg" },
  condition = conditions.lsp_attached,

  update = {
    "User",
    pattern = "LspProgressStatusUpdated",
    callback = function()
      vim.schedule(function()
        vim.cmd("redrawstatus")
      end)
    end,
  },

  on_click = {
    callback = function()
      vim.defer_fn(function()
        vim.cmd("LspInfo")
      end, 100)
    end,
    name = "heirline_LSP",
  },

  {
    provider = function()
      local result = require("lsp-progress").progress({
        max_size = math.max(math.floor(vim.o.columns / 2) - 5, 3),
      })
      return result
    end,
  },
}

return LSPMessages
