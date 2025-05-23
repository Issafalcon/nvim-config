---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
  -- when to load the breakpoints? "BufReadPost" is recommanded.
  load_breakpoints_event = { "BufReadPost" },
  -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
  perf_record = false,
  -- perform callback when loading a persisted breakpoint
  on_load_breakpoint = nil,
}

return M
