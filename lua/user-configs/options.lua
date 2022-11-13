M = {
  opt = {
    backspace = vim.opt.backspace + { "nostop" }, -- Don't stop backspace at insert
    clipboard = "unnamedplus", -- Connection to the system clipboard
    cmdheight = 0, -- hide command line unless needed
    completeopt = { "menu", "menuone", "noselect" }, -- Options for insert mode completion
    copyindent = true, -- Copy the previous indentation on autoindenting
    cursorline = true, -- Highlight the text line of the cursor
    conceallevel = 0, -- so that `` is visible in markdown files
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
    relativenumber = false, -- Show relative numberline
    scrolloff = 8, -- Number of lines to keep above and below the cursor
    shiftwidth = 2, -- Number of space inserted for indentation
    showmode = false, -- Disable showing modes in command line
    showtabline = 2, -- always display tabline
    sidescrolloff = 8, -- Number of columns to keep at the sides of the cursor
    signcolumn = "yes", -- Always show the sign column
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
    catppuccin_flavour = "mocha",
    colours_name = true, -- Whether to include custom highlight options from the UI configs
    copilot_no_tab_map = true, -- Disable tab mapping in insert mode when using copilot (so you can override the default mapping)
    EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" },
    git_messenger_always_into_popup = true, -- Always open git-messenger in a popup
    git_messenger_floating_win_opts = {
      border = "single",
      style = "minimal",
    },
    highlighturl_enabled = true, -- highlight URLs by default
    winbar_enabled = false, -- Enable winbar
    statusline_enabled = true, -- Enable statusline
    mapleader = " ", -- set leader key
    maplocalleader = " ", -- set local leader key
    zipPlugin = false, -- disable zip
    load_black = false, -- disable black
    loaded_2html_plugin = true, -- disable 2html
    loaded_getscript = true, -- disable getscript
    loaded_getscriptPlugin = true, -- disable getscript
    loaded_gzip = true, -- disable gzip
    loaded_logipat = true, -- disable logipat
    loaded_matchit = true, -- disable matchit
    loaded_netrwFileHandlers = true, -- disable netrw
    loaded_netrwPlugin = true, -- disable netrw
    loaded_netrwSettngs = true, -- disable netrw
    loaded_remote_plugins = true, -- disable remote plugins
    loaded_tar = true, -- disable tar
    loaded_tarPlugin = true, -- disable tar
    loaded_zip = true, -- disable zip
    loaded_zipPlugin = true, -- disable zip
    loaded_vimball = true, -- disable vimball
    loaded_vimballPlugin = true, -- disable vimball
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    diagnostics_enabled = true, -- enable diagnostics at start
    status_diagnostics_enabled = true, -- enable diagnostics in statusline
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available)
    quickfix_open = false, -- whether qf list is open
    loclist_open = false, -- whether loclist is open
    vimtex_view_method = "zathura", -- set default viewer for vimtex
    vimtex_view_general_viewer = "zathura", -- set default viewer for vimtex
    vimtex_compiler_latexmk = {
      build_dir = "",
      callback = 1,
      continuous = 1,
      executable = "latexmk",
      hooks = {},
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-shell-escape",
      },
    },
  },
}

return M
