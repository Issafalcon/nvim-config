vim.cmd("let g:nvcode_termcolors=256")

vim.g.catppuccin_flavour = "mocha"

-- Configure catppuccin
require("catppuccin").setup({
  transparent_background = false,
  term_colors = false,
  integrations = {
    telescope = false,
  }
})

vim.cmd([[colorscheme catppuccin]])
