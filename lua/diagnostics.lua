local icons = require("icons")

-- TODO: Move dap signs configuration into DAP config
-- local signs = {
--   { name = "DiagnosticSignError", text = icons.diagnostics.ERROR },
--   { name = "DiagnosticSignWarn", text = icons.diagnostics.WARN },
--   { name = "DiagnosticSignHint", text = icons.diagnostics.HINT },
--   { name = "DiagnosticSignInfo", text = icons.diagnostics.INFO },
--   { name = "DapStopped", text = icons.debug.Stopped, texthl = "DiagnosticWarn" },
--   { name = "DapBreakpoint", text = icons.debug.Breakpoint, texthl = "DiagnosticInfo" },
--   { name = "DapBreakpointRejected", text = icons.debug.BreakpointRejected, texthl = "DiagnosticError" },
--   { name = "DapBreakpointCondition", text = icons.debug.BreakpointCondition, texthl = "DiagnosticInfo" },
--   { name = "DapLogPoint", text = icons.debug.LogPoint, texthl = "DiagnosticInfo" },
-- }
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    header = "",
    prefix = "",
  },
})
