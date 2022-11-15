local dap_vscode = fignvim.plug.load_module_file("dap-vscode-js")
if not dap_vscode then
  return
end

local install_dir = fignvim.path.concat({ vim.fn.stdpath("data"), "mason" })

dap_vscode.setup({
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
  debugger_path = install_dir .. "/packages/js-debug-adapter",
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  log_file_level = 1, -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})
