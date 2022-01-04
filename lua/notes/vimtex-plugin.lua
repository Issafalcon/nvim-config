local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- VimTex settings
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_view_general_viewer = 'zathura'

local latexmkOptions = {
  '-verbose', '-file-line-error', '-synctex=1', '-interaction=nonstopmode', '-shell-escape'
}

vim.g.vimtex_compiler_latexmk = {
  build_dir = '',
  callback = 1,
  continuous = 1,
  executable = 'latexmk',
  hooks = {},
  options = latexmkOptions
}

keymap("n", "\\lg", [[:Start latexmk-custom-launch.sh %:p<CR>]], opts)
