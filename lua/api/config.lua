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

function fignvim.config.get_config(name)
  local config = fignvim.plug.load_module_file("user-configs." .. name)
  return config
end

function fignvim.config.get_lsp_server_config(server_name)
  local config = fignvim.plug.load_module_file("user-configs.lsp_servers." .. server_name)
  return config
end

fignvim.config.set_shell_as_powershell = function()
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

fignvim.config.set_win32yank_wsl_as_clip = function()
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

if fignvim.plug.is_available("nvim-mapper") then
  local mapper = require("nvim-mapper")

  fignvim.config.map = function(mode, keys, cmd, options, category, unique_identifier, description)
    mapper.map(mode, keys, cmd, options, category, unique_identifier, description)
  end
  fignvim.config.map_buf = function(bufnr, mode, keys, cmd, options, category, unique_identifier, description)
    mapper.map_buf(bufnr, mode, keys, cmd, options, category, unique_identifier, description)
  end
  fignvim.config.map_virtual = function(mode, keys, cmd, options, category, unique_identifier, description)
    mapper.map_virtual(mode, keys, cmd, options, category, unique_identifier, description)
  end
  fignvim.config.map_buf_virtual = function(mode, keys, cmd, options, category, unique_identifier, description)
    mapper.map_buf_virtual(mode, keys, cmd, options, category, unique_identifier, description)
  end
else
  fignvim.config.map = function(mode, keys, cmd, options, _, _, _) vim.api.nvim_set_keymap(mode, keys, cmd, options) end
  fignvim.config.map_buf =
    function(bufnr, mode, keys, cmd, options, _, _, _) vim.api.nvim_buf_set_keymap(bufnr, mode, keys, cmd, options) end
  fignvim.config.map_virtual = function(_, _, _, _, _, _, _) return end
  fignvim.config.map_buf_virtual = function(_, _, _, _, _, _, _) return end
end

--- Recurses through a set of FigNvimMappings and creates a set of keymaps for them
---@param mapping_group table<string, FigNvimMapping>
---@param group_name string The name of the mapping group
---@param bufnr? number Optional buffer number to create keymapping for
function fignvim.config.create_mapping_group(mapping_group, group_name, bufnr)
  for key, mapping in pairs(mapping_group) do
    fignvim.config.create_mapping(key, group_name, mapping, bufnr)
  end
end

--- Create a mapping based on a FigNvimMapping
---@param id string The unique identifier of the mapping
---@param group_name string The name of the mapping group
---@param mapping FigNvimMapping The mapping parameters
---@param bufnr? number Optional buffer number to create keymapping for
function fignvim.config.create_mapping(id, group_name, mapping, bufnr)
  local opts = mapping.opts or { silent = true }

  if bufnr then
    opts.buffer = bufnr
  end

  if mapping.isVirtual then
    fignvim.config.map_virtual(mapping.mode, mapping.lhs, "", {}, group_name, id, mapping.desc)
  else
    fignvim.config.map(mapping.mode, mapping.lhs, mapping.rhs, opts, group_name, id, mapping.desc)
  end
end
return fignvim.config
