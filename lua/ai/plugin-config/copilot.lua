---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    keymap = {
      accept = false, -- handled by nvim-cmp / blink.cmp
      next = "<M-]>",
      prev = "<M-[>",
    },
  },
  panel = { enabled = false },
  filetypes = {
    markdown = true,
    help = true,
  },
}

M.setup = function()
  require("copilot").setup(M.lazy_opts)
end

return M
