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

    fignvim.config.map = function(mode, keys, cmd, options, category, unique_identifier,
                     description)
        mapper.map(mode, keys, cmd, options, category, unique_identifier,
                   description)
    end
    fignvim.config.map_buf = function(bufnr, mode, keys, cmd, options, category, unique_identifier,
                         description)
        mapper.map_buf(bufnr, mode, keys, cmd, options, category, unique_identifier,
                       description)
    end
    fignvim.config.map_virtual = function(mode, keys, cmd, options, category,
                             unique_identifier, description)
        mapper.map_virtual(mode, keys, cmd, options, category,
                           unique_identifier, description)
    end
    fignvim.config.map_buf_virtual = function(mode, keys, cmd, options, category,
                                 unique_identifier, description)
        mapper.map_buf_virtual(mode, keys, cmd, options, category,
                               unique_identifier, description)
    end
else
    fignvim.config.map = function(mode, keys, cmd, options, _, _, _)
        vim.api.nvim_set_keymap(mode, keys, cmd, options)
    end
    fignvim.config.map_buf = function(bufnr, mode, keys, cmd, options, _, _, _)
        vim.api.nvim_buf_set_keymap(bufnr, mode, keys, cmd, options)
    end
    fignvim.config.map_virtual = function(_, _, _, _, _, _, _) return end
    fignvim.config.map_buf_virtual = function(_, _, _, _, _, _, _) return end

end

return fignvim.config
