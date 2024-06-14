local conditions = require("heirline.conditions")

local LspList = {
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach" },

  hl = { fg = "lsp_status_fg", bg = "component_bg" },

  on_click = {
    callback = function()
      vim.defer_fn(function()
        vim.cmd("LspInfo")
      end, 100)
    end,
    name = "heirline_LSP",
  },

  provider = function()
    local names = {}
    for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      table.insert(names, server.name)
    end
    return " [" .. table.concat(names, ",") .. "] "
  end,
}

return LspList
