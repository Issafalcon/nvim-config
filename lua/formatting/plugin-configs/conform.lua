---@type FigNvimPluginConfig
local M = {}

M.lazy_init = function()
  fignvim.formatting.register({
    name = "conform.nvim",
    priority = 100,
    primary = true,
    format = function(buf)
      require("conform").format({ bufnr = buf })
    end,
    sources = function(buf)
      local ret = require("conform").list_formatters(buf)

      ---@param v conform.FormatterInfo
      return vim.tbl_map(function(v)
        return v.name
      end, ret)
    end,
  })
end

M.lazy_opts = {
  default_format_opts = {
    timeout_ms = 3000,
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
    lsp_format = "fallback", -- not recommended to change
  },
  formatters_by_ft = {
    lua = { "stylua" },
    fish = { "fish_indent" },
    sh = { "shfmt" },
  },
  formatters = {
    injected = { options = { ignore_errors = true } },
  },
}

M.setup = function()
  M.lazy_init()
  require("conform").setup(M.lazy_opts)
end

return M
