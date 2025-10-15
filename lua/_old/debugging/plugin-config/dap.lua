---@type FigNvimPluginConfig
local M = {}

M.dap_install_dir = fignvim.path.concat({ vim.fn.stdpath("data"), "mason" })

M.lazy_config = function()
  local dap = require("dap")

  -- Settings
  dap.defaults.fallback.terminal_win_cmd = "80vsplit new"

  -- dap.set_log_level("TRACE") -- Verbose logging
  vim.fn.sign_define("DapBreakpoint", { text = "👊", texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "✋", texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "👉", texthl = "", linehl = "", numhl = "" })

  -- Adapters
  local netcoredbg_install_dir

  if vim.fn.has("win32") == 1 then
    netcoredbg_install_dir = M.dap_install_dir .. "/packages/netcoredbg/netcoredbg/netcoredbg.exe"
  else
    netcoredbg_install_dir = M.dap_install_dir .. "/packages/netcoredbg/netcoredbg"
  end

  dap.adapters.netcoredbg = {
    type = "executable",
    command = netcoredbg_install_dir,
    args = { "--interpreter=vscode" },
  }

  dap.adapters.bashdb = {
    type = "executable",
    command = M.dap_install_dir .. "/packages/bash-debug-adapter/bash-debug-adapter",
    name = "bashdb",
  }

  dap.adapters.nlua = function(callback, config)
    callback({
      type = "server",
      host = config.host or "127.0.0.1",
      port = config.port or 8086,
    })
  end

  -- Can't get this to work on WSL currently, but seems to be the best best to try
  require("dap-vscode-js").setup({
    debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
    log_console_level = vim.log.levels.TRACE,
    adapters = {
      "chrome",
      "pwa-node",
      "pwa-chrome",
      "pwa-msedge",
      "node-terminal",
      "pwa-extensionHost",
    },
  })

  fignvim.debug.setup_debug_configs()
end

return M
