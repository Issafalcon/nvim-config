local maximizer_keys = {
  { "n", "<leader>m", ":MaximizerToggle!<CR>", { desc = "Toggle maximizer (current window)" } },
}

local maximizer_spec = {
  "szw/vim-maximizer",
  cmd = "MaximizerToggle",
  keys = fignvim.config.make_lazy_keymaps(maximizer_keys),
}

local bufferline_spec = {
  "akinsho/bufferline.nvim",
  event = "UIEnter",
  opts = {
    options = {
      offsets = {
        { filetype = "NvimTree", text = "", padding = 1 },
        { filetype = "neo-tree", text = "", padding = 1 },
        { filetype = "Outline", text = "", padding = 1 },
      },
      buffer_close_icon = fignvim.ui.get_icon("BufferClose"),
      modified_icon = fignvim.ui.get_icon("FileModified"),
      close_icon = fignvim.ui.get_icon("NeovimClose"),
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 20,
      separator_style = "thin",
    },
  },
}

local window_picker_spec = {
  "s1n7ax/nvim-window-pickerh",
  event = "BufReadPost",
  opts = function()
    local colours = require("user-configs.ui").colours
    return {
      use_winbar = "smart",
      other_win_hl_color = colours.grey_4,
    }
  end,
}

return {
  window_picker_spec,
  maximizer_spec,
  bufferline_spec,
}
