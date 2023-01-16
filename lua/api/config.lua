fignvim.config = {}

--- Set vim options with a nested table like API with the format vim.<first_key>.<second_key>.<value>
---@param options table the nested table of vim options
fignvim.config.set_vim_opts = function(options)
  for scope, table in pairs(options) do
    for setting, value in pairs(table) do
      vim[scope][setting] = value
    end
  end
end

--- Get the configuration for a given plugin (name must match file in "plugin-configs" folder)
---@param plugin_name string Name of the plugin
---@param required? boolean Whether ot not the mappings are required
---@return table The mappings for the plugin
function fignvim.config.get_plugin_mappings(plugin_name, required)
  local mappings = fignvim.plug.load_module_file("user-configs.mappings", required)
  local plug_maps = mappings["plugin_mappings"][plugin_name]

  if not plug_maps then
    fignvim.ui.notify("No plugin mappings found for " .. plugin_name, "warn")
  end
  return plug_maps
end

function fignvim.config.set_shell_as_powershell()
  -- Adding -NoProfile stops powershell from loading the profile every time shell command is run
  -- but still loads it when creating Neovim terminal buffer
  vim.cmd([[let &shell = executable('pwsh') ? 'pwsh' : 'powershell']])
  vim.cmd(
    [[let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;']]
  )
  vim.cmd([[let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait']])
  vim.cmd([[let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode']])
  vim.cmd([[set shellquote= shellxquote=]])
end

function fignvim.config.set_win32yank_wsl_as_clip()
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
  }
end

--- register mappings table with which-key
-- @param mappings nested table of mappings where the first key is the mode, the second key is the prefix, and the value is the mapping table for which-key
-- @param opts table of which-key options when setting the mappings (see which-key documentation for possible values)
function fignvim.config.which_key_register(mappings, opts)
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    return
  end
  for mode, prefixes in pairs(mappings) do
    for prefix, mapping_table in pairs(prefixes) do
      which_key.register(
        mapping_table,
        vim.tbl_deep_extend("force", {
          mode = mode,
          prefix = prefix,
          buffer = nil,
          silent = true,
          noremap = true,
          nowait = true,
        }, opts or {})
      )
    end
  end
end

--- Create a mapping based on a FigNvimMapping
---@param mapping FigNvimMapping The mapping parameters
---@param bufnr? number Optional buffer number to create keymapping for
function fignvim.config.create_mapping(mapping, bufnr)
  local opts = mapping.opts or { silent = true }

  if bufnr then
    opts.buffer = bufnr
  end

  vim.keymap.set(mapping.mode, mapping.lhs, mapping.rhs, opts)
end

function fignvim.config.setup_keymaps()
  -- Requiring these files will allow legendary to bind keys by calling the
  -- underlying vim.keymap.set command, and also create records for virtual keybindings
  -- Whichkey registry sets up groups for certain patterns of keys
  require("plugin-configs.which-key-register")
  require("plugin-configs.legendary")
end

return fignvim.config
