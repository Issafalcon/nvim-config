-- Colourschemes
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = false,
  term_colors = true,
  integrations = {
    telescope = true,
    aerial = true,
    gitsigns = true,
    cmp = true,
    nvimtree = true,
    mason = true,
  },
  dim_inactive = {
    enabled = true,
    shade = "dark",
    percentage = 0.10,
  },
})

vim.cmd.colorscheme("catppuccin")
