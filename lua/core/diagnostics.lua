-- TODO: Move dap signs configuration into DAP config
local signs = {
  { name = "DiagnosticSignError", text = fignvim.ui.get_icon("DiagnosticError") },
  { name = "DiagnosticSignWarn", text = fignvim.ui.get_icon("DiagnosticWarn") },
  { name = "DiagnosticSignHint", text = fignvim.ui.get_icon("DiagnosticHint") },
  { name = "DiagnosticSignInfo", text = fignvim.ui.get_icon("DiagnosticInfo") },
  { name = "DiagnosticSignError", text = fignvim.ui.get_icon("DiagnosticError") },
  { name = "DapStopped", text = fignvim.ui.get_icon("DapStopped"), texthl = "DiagnosticWarn" },
  { name = "DapBreakpoint", text = fignvim.ui.get_icon("DapBreakpoint"), texthl = "DiagnosticInfo" },
  { name = "DapBreakpointRejected", text = fignvim.ui.get_icon("DapBreakpointRejected"), texthl = "DiagnosticError" },
  { name = "DapBreakpointCondition", text = fignvim.ui.get_icon("DapBreakpointCondition"), texthl = "DiagnosticInfo" },
  { name = "DapLogPoint", text = fignvim.ui.get_icon("DapLogPoint"), texthl = "DiagnosticInfo" },
}

for _, sign in ipairs(signs) do
  if not sign.texthl then sign.texthl = sign.name end
  vim.fn.sign_define(sign.name, sign)
end

vim.diagnostic.config({
  virtual_text = false,
  signs = { active = signs },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
