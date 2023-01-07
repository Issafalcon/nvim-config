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

function fignvim.config.get_lsp_server_config(server_name)
  local module_file = "user-configs.lsp_servers." .. server_name
  local config = fignvim.plug.load_module_file(module_file)
  return config
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
--- Extract all mappings from 'user-configs.mappings' and convert into table for legendary.nvim
function fignvim.config.get_legendary_keymaps()
  local legendary_map_table = {}

  local function create_legendary_map_table(map_config, as_virtual)
    local legendary_map = {
      map_config.lhs,
      map_config.rhs,
      description = map_config.desc,
      mode = map_config.mode,
      opts = map_config.opts or {},
    }

    -- Virtual keymaps (i.e. Ones set by plugins, but included in mappings config to register them as non-bound maps)
    --  need to omit the handler element (i.e. the 'rhs' option)
    if map_config.isVirtual or as_virtual then
      table.remove(legendary_map, 2)
    end

    return legendary_map
  end

  local general_mappings = require("user-configs.mappings").general_mappings

  -- First create the general mappings groups
  for group, group_mappings in pairs(general_mappings) do
    local legendary_maps = {}
    for _, map in pairs(group_mappings) do
      table.insert(legendary_maps, create_legendary_map_table(map))
    end
    table.insert(legendary_map_table, {
      itemgroup = group,
      keymaps = legendary_maps,
    })
  end

  -- Then create the plugin mappings groups
  local plugin_mapping_dictionary = {
    ["Comment.nvim"] = "Commenting",
    ["toggleterm.nvim"] = "Terminal",
    ["vim-easy-align"] = "EasyAlign",
    ["telescope.nvim"] = "Searching",
    ["aerial.nvim"] = "Aerial",
    ["neo-tree.nvim"] = "NeoTree",
    ["nvim-spectre"] = "Searching",
    ["nvim-cmp"] = "Completion",
    ["LuaSnip"] = "Snippets",
    ["copilot.vim"] = "Copilot",
    ["diffview.nvim"] = "Diffview",
    ["vimtex"] = "LaTex",
    ["neotest"] = "Neotest",
    ["cheatsheet.nvim"] = "Cheatsheet",
    ["vim-maximizer"] = "Maximizer",
    ["nvim-dap"] = "Debug",
    ["neogen"] = "Docstring",
    ["rnvimr"] = "Ranger",
    ["undotree"] = "Undotree",
    ["nvim-neoclip.lua"] = "Neoclip",
    ["vim-cutlass"] = "Cutlass",
    ["session-lens"] = "Session",
    ["vim-subversive"] = "CopyPaste",
    ["leap.nvim"] = "Searching",
  }

  for plugin, groupname in pairs(plugin_mapping_dictionary) do
    if fignvim.plug.is_available(plugin) then
      local plugin_mappings = fignvim.config.get_plugin_mappings(plugin)
      local legendary_maps = {}
      for _, map in pairs(plugin_mappings) do
        table.insert(legendary_maps, create_legendary_map_table(map))
      end
      table.insert(legendary_map_table, {
        itemgroup = groupname,
        keymaps = legendary_maps,
      })
    end
  end

  -- Then add the LSP mappings as virtual mappings (they are mapped per buffer during the LSP setup)
  -- First create the general mappings groups
  local lsp_mappings = require("user-configs.mappings").lsp_mappings
  for group, lsp_maps in pairs(lsp_mappings) do
    local legendary_maps = {}
    for _, map in pairs(lsp_maps) do
      table.insert(legendary_maps, create_legendary_map_table(map, true))
    end
    table.insert(legendary_map_table, {
      itemgroup = group,
      keymaps = legendary_maps,
    })
  end

  return legendary_map_table
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
