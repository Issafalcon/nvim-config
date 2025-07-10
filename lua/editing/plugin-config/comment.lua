---@type FigNvimPluginConfig
local M = {}

M.lazy_config = function()
  local comment = require("Comment")
  comment.setup({
    opleader = {
      line = "gc",
      block = "gb",
    },
    toggler = {
      line = "gcc",
      block = "gbc",
    },
    extra = {
      above = "gcO",
      below = "gco",
      eol = "gcA",
    },
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  })
end
return M
