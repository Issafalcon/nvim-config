local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
  impatient.enable_profile()
end

-- 1. Get all the required Fignvim API functions and commands required for setup
for _, source in ipairs({
  "api",
  "api.lsp",
  "commands.autocommands",
  "commands.usercommands",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
  end
end

-- 3. Initialise the plugin manager and load all plugins
fignvim.plug.initialise_packer()
fignvim.plug.setup_plugins()

require "options"
require "keymappings"
-- require "plugins"
require "autocommands"
require "colourscheme"
require "helpers"

require "utils"
require "version-control"
require "sessions"
require "completion"
require "searching"
require "lsp"
require "syntax-highlighting"
require "tabline"
require "commenting"
require "quickfix"
require "testing"
require "debugging"
require "notes"
require "navigation"
