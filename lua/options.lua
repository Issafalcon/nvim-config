-- :help options
vim.opt.backup = false                                            -- creates a backup file
vim.opt.clipboard = "unnamedplus"                                 -- allows neovim to access the system clipboard
vim.opt.cmdheight = 2                                             -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menu","noinsert","menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                                          -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                                    -- the encoding written to a file
vim.opt.hlsearch = true                                           -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                                         -- ignore case in search patterns
vim.opt.mouse = "a"                                               -- allow the mouse to be used in neovim
vim.opt.pumheight = 25                                            -- pop up menu height
vim.opt.showmode = false                                          -- shows the mode
vim.opt.showtabline = 2                                           -- always show tabs
vim.opt.smartcase = true                                          -- smart case
vim.opt.splitbelow = true                                         -- force all horizontal splits to go below current window
vim.opt.splitright = true                                         -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                                          -- creates a swapfile
vim.opt.termguicolors = true                                      -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                                         -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                                           -- enable persistent undo
vim.opt.updatetime = 300                                          -- faster completion (4000ms default)
vim.opt.writebackup = false                                       -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

-- Indenting
vim.opt.smartindent = true                                        -- make indenting smarter again
vim.opt.expandtab = false                                          -- convert tabs to spaces
vim.opt.shiftwidth = 2                                            -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2                                               -- insert 2 spaces for a tab
vim.opt.softtabstop = 0
vim.opt.cursorline = false                                        -- highlight the current line
vim.opt.number = true                                             -- set numbered lines
vim.opt.relativenumber = false                                    -- set relative numbered lines
vim.opt.numberwidth = 4                                           -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes:2"                                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                                              -- display lines as one long line
vim.opt.scrolloff = 8                                             -- is one of my fav
vim.opt.sidescrolloff = 8
vim.opt.guifont = "firacode nerd font:h17"                        -- the font used in graphical neovim applications
vim.opt.hidden = true
vim.opt.shortmess:append "c"

-- Sessions
vim.opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winpos,terminal"

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd "set inccommand=split"
vim.cmd [[set formatoptions-=cro]]
vim.cmd "syntax on"
vim.cmd "filetype plugin indent on"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set iskeyword+=@]]
vim.cmd [[set list]]
vim.cmd [[set listchars=tab:\⍿·,eol:·,trail:\×,multispace:···]]

-- Using winyank for wsl
if vim.fn.has('win32unix') and vim.fn.has('wsl') then
  vim.g.clipboard = {
      name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf"
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf"
    }
  }
end
