fignvim.updater = {}

--- Reload the AstroNvim configuration live (Experimental)
-- @param quiet boolean to quietly execute or send a notification
function fignvim.updater.reload(quiet)
  -- stop LSP if it is running
  if vim.fn.exists(":LspStop") ~= 0 then
    vim.cmd.LspStop()
  end
  local reload_module = require("plenary.reload").reload_module
  -- unload FigNvim configuration files
  reload_module("api")
  reload_module("api.lsp")
  reload_module("commands.autocommands")
  reload_module("commands.usercommands")
  reload_module("user-configs.options")
  reload_module("user-configs.mappings")
  reload_module("user-configs.plugins")
  -- manual unload some plugins that need it if they exist
  reload_module("nvim-cmp")
  reload_module("nvim-mapper")
  -- source the FigNvim configuration
  local reloaded, _ = pcall(dofile, vim.fn.expand("$MYVIMRC"))
  -- if successful reload and not quiet, display a notification
  if reloaded and not quiet then
    fignvim.ui.notify("Reloaded FigNvim")
  end
end

return fignvim.updater
