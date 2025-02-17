---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  snippet_support = "luasnip",
  languages = {
    cs = {
      template = {
        annotation_convention = "xmldoc",
      },
    },
  },
}

M.setup = function()
  require("neogen").setup(M.lazy_opts)
end

return M
