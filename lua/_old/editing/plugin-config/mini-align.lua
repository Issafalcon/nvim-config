-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md

local keys = require("keymaps").Editing

---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    start = keys.Align,
    start_with_preview = keys.AlignWithPreview,
  },

  -- Default options controlling alignment process
  options = {
    split_pattern = "",
    justify_side = "left",
    merge_delimiter = "",
  },

  -- Default steps performing alignment (if `nil`, default is used)
  steps = {
    pre_split = {},
    split = nil,
    pre_justify = {},
    justify = nil,
    pre_merge = {},
    merge = nil,
  },

  -- Whether to disable showing non-error feedback
  -- This also affects (purely informational) helper messages shown after
  -- idle time if user input is required.
  silent = false,
}

return M
