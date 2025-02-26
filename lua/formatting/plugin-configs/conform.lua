---@type FigNvimPluginConfig
local M = {}

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
  require("conform").setup(M.lazy_opts)
end

return M
