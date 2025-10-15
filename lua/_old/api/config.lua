fignvim.config = {}

--- Set vim options with a nested table like API with the format vim.<first_key>.<second_key>.<value>
---@param options table the nested table of vim options
function fignvim.config.set_vim_opts(options)
  for scope, table in pairs(options) do
    for setting, value in pairs(table) do
      vim[scope][setting] = value
    end
  end
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
    cache_enabled = 1,
    -- Recommended from the :h clipboard_wsl section but win32yank is faster (as long as you keep it updated!)
    -- name = "wsl-clipboard",
    -- copy = {
    --   ["+"] = "clip.exe",
    --   ["*"] = "clip.exe",
    -- },
    -- paste = {
    --   ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --   ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    -- },
  }

  -- sync with system clipboard on focus
  -- vim.api.nvim_create_autocmd({ "FocusGained" }, {
  --   pattern = { "*" },
  --   command = [[call setreg("@", getreg("+"))]],
  -- })

  -- sync with system clipboard on focus
  -- vim.api.nvim_create_autocmd({ "FocusLost" }, {
  --   pattern = { "*" },
  --   command = [[call setreg("+", getreg("@"))]],
  -- })
end

return fignvim.config
