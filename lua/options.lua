vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Other custom global variables
vim.g.diagnostics_enabled = true
vim.g.autoformat = true -- enable autoformat

vim.g.autopairs_enabled = true -- enable autopairs at start
vim.g.status_diagnostics_enabled = true -- enable diagnostics in statusline
vim.g.inlay_hint_default_enable = false -- enable inlay hints by default for each LSP that supports

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = vim.opt.listchars
  + {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
    space = "⋅",
    eol = "↴",
  }

vim.opt.backspace = vim.opt.backspace + { "nostop" } -- Don't stop backspace at insert

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Enable break indent (wrapped lines will continue visually indented)
vim.o.breakindent = true

vim.o.cmdheight = 1 -- hide command line unless needed
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Options for insert mode completion

vim.o.copyindent = true -- Copy the previous indentation on autoindenting

-- Show which line your cursor is on
vim.o.cursorline = true

-- so that `` is visible in markdown files
vim.o.conceallevel = 1

-- Enable the use of space in tab
vim.o.expandtab = true

vim.o.fileencoding = "utf-8" -- File content encoding for the buffer

vim.o.winborder = "rounded"

vim.opt.fillchars = {
  eob = " ", -- Disable `~` on nonexistent lines
  horiz = "-",
  horizup = "-",
  horizdown = "-",
  vert = "|",
  vertleft = "|",
  vertright = "|",
  verthoriz = "|",
}

vim.o.history = 100 -- Number of commands to remember in a history table

vim.o.inccommand = "split" -- Show the effect of a command incrementally
vim.opt.iskeyword = vim.opt.iskeyword + { "-", "@" } -- Treat dash separated words as a word text object
vim.o.laststatus = 3 -- globalstatus

-- Enable mouse support
vim.o.mouse = "a"

-- Show line numbers by default
vim.o.number = true
vim.o.preserveindent = true -- Preserve indent structure as much as possible
vim.o.pumheight = 10 -- Height of the pop up menu

-- Better QF list UI (from https://github.com/kevinhwang91/nvim-bqf#format-new-quickfix)
vim.o.qftf = "{info -> v:lua.fignvim.ui.qftf(info)}"

vim.o.relativenumber = false -- Show relative numberline
vim.o.scrolloff = 8 -- Number of lines to keep above and below the cursor

vim.opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winpos",
  "terminal",
}

vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 2 -- Number of space inserted for indentation

-- Disable showing modes in command line
vim.o.showmode = false

vim.o.showtabline = 2 -- always display tabline

vim.o.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor

vim.o.signcolumn = "yes:2" -- Always show the sign column

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.smartcase = true
vim.o.ignorecase = true

vim.o.splitbelow = true -- Splitting a new window below the current one
vim.o.splitright = true -- Splitting a new window at the right of the current one
vim.o.swapfile = false -- Disable use of swapfile for the buffer
vim.o.tabstop = 2 -- Number of space in a tab
vim.o.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.o.timeoutlen = 300 -- Length of time to wait for a mapped sequence

-- Save undo history
vim.o.undofile = true
vim.o.updatetime = 300 -- Length of time to wait before triggering the plugin
vim.o.wrap = false -- Disable wrapping of lines longer than the width of window
vim.o.writebackup = false -- Disable making a backup before overwriting a file
vim.o.backup = false
vim.o.smoothscroll = true

-- Set Python3 host program for neovim
--  See `:help g:python3_host_prog`
if vim.fn.has("win32") == 1 then
  vim.g.python3_host_prog = "~/AppData/Local/python3/Envs/neovim/Scripts/python.exe"
else
  vim.g.python3_host_prog = "~/python3/envs/neovim/bin/python3"
end

if vim.fn.has("win32") == 1 then
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

if vim.fn.has("wsl") == 1 then
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
end
