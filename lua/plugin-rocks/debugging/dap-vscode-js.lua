-- Can't get this to work on WSL currently, but seems to be the best best to try
require("dap-vscode-js").setup({
  -- Manually intalled via the dotfiles nvim install script
  debugger_path = vim.fn.stdpath("data") .. "/vscode-js-debug",
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
