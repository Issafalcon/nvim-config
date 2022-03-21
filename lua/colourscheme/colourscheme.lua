vim.cmd("let g:nvcode_termcolors=256")

vim.g.material_style = "darker"

require("material").setup({

  contrast = {
    sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
    floating_windows = true, -- Enable contrast for floating windows
    line_numbers = false, -- Enable contrast background for line numbers
    sign_column = false, -- Enable contrast background for the sign column
    cursor_line = false, -- Enable darker background for the cursor line
    non_current_windows = true, -- Enable darker background for non-current windows
    popup_menu = true, -- Enable lighter background for the popup menu
  },

  italics = {
    comments = true, -- Enable italic comments
    keywords = false, -- Enable italic keywords
    functions = false, -- Enable italic functions
    strings = false, -- Enable italic strings
    variables = false, -- Enable italic variables
  },

  contrast_filetypes = { -- Specify which windows get the contrasted (darker) background
    "terminal", -- Darker terminal background
    "packer", -- Darker packer background
    "qf", -- Darker qf list background
  },

  text_contrast = {
    lighter = false, -- Enable higher contrast text for lighter style
    darker = true, -- Enable higher contrast text for darker style
  },

  disable = {
    background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
    term_colors = false, -- Prevent the theme from setting terminal colors
    eob_lines = true, -- Hide the end-of-buffer lines
    borders = false,
  },

  custom_colors = {
    blue = "#FF9CAC",
  }, -- Overwrite highlights with your own
})

vim.cmd("colorscheme spacedark")

vim.api.nvim_set_keymap(
  "n",
  "<leader>tm",
  [[<Cmd>lua require('material.functions').toggle_style()<CR>]],
  { noremap = true, silent = true }
)
