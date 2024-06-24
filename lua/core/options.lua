local options = {
  opt = {
    backspace = vim.opt.backspace + { "nostop" }, -- Don't stop backspace at insert
    clipboard = "", -- Connection to the system clipboard
    cmdheight = 1, -- hide command line unless needed
    completeopt = { "menu", "menuone", "noselect" }, -- Options for insert mode completion
    copyindent = true, -- Copy the previous indentation on autoindenting
    cursorline = true, -- Highlight the text line of the cursor
    conceallevel = 1, -- so that `` is visible in markdown files
    expandtab = true, -- Enable the use of space in tab
    fileencoding = "utf-8", -- File content encoding for the buffer
    fillchars = {
      eob = " ", -- Disable `~` on nonexistent lines
      horiz = "-",
      horizup = "-",
      horizdown = "-",
      vert = "|",
      vertleft = "|",
      vertright = "|",
      verthoriz = "|",
    },
    history = 100, -- Number of commands to remember in a history table
    ignorecase = true, -- Case insensitive searching
    inccommand = "split", -- Show the effect of a command incrementally
    iskeyword = vim.opt.iskeyword + { "-", "@" }, -- Treat dash separated words as a word text object
    laststatus = 3, -- globalstatus
    lazyredraw = true, -- lazily redraw screen
    list = true, -- Show some invisible characters
    listchars = vim.opt.listchars + { space = "⋅", eol = "↴" }, -- Invisible characters
    mouse = "a", -- Enable mouse support
    number = true, -- Show numberline
    preserveindent = true, -- Preserve indent structure as much as possible
    pumheight = 10, -- Height of the pop up menu
    -- Better QF list UI (from https://github.com/kevinhwang91/nvim-bqf#format-new-quickfix)
    qftf = "{info -> v:lua.fignvim.ui.qftf(info)}",
    relativenumber = false, -- Show relative numberline
    scrolloff = 8, -- Number of lines to keep above and below the cursor
    sessionoptions = {
      "blank",
      "buffers",
      "curdir",
      "folds",
      "help",
      "tabpages",
      "winpos",
      "terminal",
    },
    shiftwidth = 2, -- Number of space inserted for indentation
    showmode = false, -- Disable showing modes in command line
    showtabline = 2, -- always display tabline
    sidescrolloff = 8, -- Number of columns to keep at the sides of the cursor
    signcolumn = "yes:2", -- Always show the sign column
    smartcase = true, -- Case sensitivie searching
    splitbelow = true, -- Splitting a new window below the current one
    splitright = true, -- Splitting a new window at the right of the current one
    swapfile = false, -- Disable use of swapfile for the buffer
    tabstop = 2, -- Number of space in a tab
    termguicolors = true, -- Enable 24-bit RGB color in the TUI
    timeoutlen = 300, -- Length of time to wait for a mapped sequence
    undofile = true, -- Enable persistent undo
    updatetime = 300, -- Length of time to wait before triggering the plugin
    wrap = false, -- Disable wrapping of lines longer than the width of window
    writebackup = false, -- Disable making a backup before overwriting a file
    backup = false,
  },
  g = {
    mapleader = " ", -- set leader key
    maplocalleader = " ", -- set local leader key
    diagnostics_enabled = true, -- enable diagnostics at start
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    autopairs_enabled = true, -- enable autopairs at start
    status_diagnostics_enabled = true, -- enable diagnostics in statusline
    fignvim_modules = {}, -- Track modules
    fignvim_plugins = {}, -- Track modules
  },
}

if vim.fn.has("win32") == 1 then
  options.g.python3_host_prog = "~/AppData/Local/python3/Envs/neovim/Scripts/python.exe"
else
  options.g.python3_host_prog = "~/python3/envs/neovim/bin/python3"
end

fignvim.config.set_vim_opts(options)
