vim.pack.add({
  { src = "https://github.com/kevinhwang91/nvim-bqf" },
})

local colourscheme = require("colourscheme")

vim.g.BqfPreviewBorder = { fg = colourscheme.colours.vue }
vim.g.BqfPreviewRange = { link = "Search" }

require("bqf").setup({
  auto_enable = true,
  auto_resize_height = true, -- highly recommended enable
  preview = {
    win_height = 12,
    win_vheight = 12,
    delay_syntax = 80,
    border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
    show_title = false,
    should_preview_cb = function(bufnr, _)
      local ret = true
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local fsize = vim.fn.getfsize(bufname)
      if fsize > 100 * 1024 then
        -- skip file size greater than 100k
        ret = false
      elseif bufname:match("^fugitive://") then
        -- skip fugitive buffer
        ret = false
      end
      return ret
    end,
  },
  filter = {
    fzf = {
      action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
      extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
    },
  },
})
