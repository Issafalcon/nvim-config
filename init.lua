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

--2. Load general options
local options = require("user-configs.options")
fignvim.config.set_vim_opts(options)

if vim.fn.has("win32") == 1 then
  fignvim.config.set_shell_as_powershell()
end

if vim.fn.has("wsl") then
  fignvim.config.set_win32yank_wsl_as_clip()
end

-- 3. Initialise the plugin manager and load all plugins
fignvim.plug.initialise_packer()
fignvim.plug.setup_plugins()

-- 4. Set up some UI features
fignvim.ui.set_colourscheme()
fignvim.ui.configure_diagnostics()

-- 5. Set up the LSP servers
fignvim.lsp.setup_all_lsp_servers()

-- 6. Create remaining general mappings
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { silent = true}) -- Prep for space to be leader key

require "keymappings"
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
