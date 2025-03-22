---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  image = { enabled = true },
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  indent = { enabled = false },
  input = { enabled = false },
  picker = { enabled = false },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
}

M.lazy_config = function(_, opts)
  local notify = vim.notify
  require("snacks").setup(opts)
  -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
  -- this is needed to have early notifications show up in noice history
  if fignvim.plug.has("noice.nvim") then
    vim.notify = notify
  end
end

return M
