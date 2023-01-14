local spectre_keys = {
  {
    "n",
    "<leader>S",
    ":lua require('spectre').open()<CR>",
    { desc = "Open Spectre Panel" },
  },
  {
    "n",
    "<leader>sw",
    ":lua require('spectre').open_visual({select_word=true})<CR>",
    { desc = "Search for current word under cursor" },
  },
  {
    "v",
    "<leader>s",
    ":lua require('spectre').open_visual()<CR>",
    { desc = "Search for current selection" },
  },
  {
    "n",
    "<leader>sp",
    ":lua require('spectre').open_file_search()<CR>",
    { desc = "Search for text in current file" },
  },
}

local subversive_keys = {
  {
    "n",
    "s",
    "<plug>(SubversiveSubstitute)",
    { desc = "Subversive: Substitute the motion specified with whatever is in default yank register" },
  },
  {
    "n",
    "ss",
    "<plug>(SubversiveSubstituteLine)",
    { desc = "Subversive: Substitute the line with whatever is in default yank register" },
  },
  {
    "n",
    "S",
    "<plug>(SubversiveSubstituteToEndOfLine)",
    { desc = "Subversive: Substitute everything until the end of the line with whatever is in the yank register" },
  },
  {
    { "n", "x" },
    "<leader>s",
    "<plug>(SubversiveSubstituteRange)",
    {
      desc = "Subversive: Substitute all instances of the text in the first motion that exist in the text within the second motion",
    },
  },
  {
    "n",
    "<leader>ss",
    "<plug>(SubversiveSubstituteWordRange)",
    { desc = "Subversive: Substitute all instances of word under the cursor within the motion specified" },
  },
  {
    { "n", "x" },
    "<leader><leader>v",
    "<plug>(SubversiveSubvertRange)",
    {
      desc = "Subversive: Subvert all instances of the text in the first motion that exist in the text within the second motion",
    },
  },
  {
    "n",
    "<leader><leader>vv",
    "<plug>(SubversiveSubvertWordRange)",
    { desc = "Subversive: Subvert all instances of word under the cursor within the motion specified" },
  },
}

local bqf_spec = {
  "kevinhwang91/nvim-bqf",
  event = "QuickFixCmdPre",
  keys = fignvim.config.make_lazy_keymaps(require("user-configs.mappings").lists, true),
  opts = {
    auto_enable = true,
    auto_resize_height = true, -- highly recommended enable
    preview = {
      win_height = 12,
      win_vheight = 12,
      delay_syntax = 80,
      border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
      show_title = false,
      should_preview_cb = function(bufnr, qwinid)
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
  },
}

local spectre_spec = {
  "windwp/nvim-spectre",
  keys = fignvim.config.make_lazy_keymaps(spectre_keys),
  config = true,
}

local subversive_spec = {
  "svermeulen/vim-subversive",
  event = "BufEnter",
  keys = fignvim.config.make_lazy_keymaps(subversive_keys),
}

local vim_abolish_spec = {
  "tpope/vim-abolish",
  event = "BufEnter",
}

return {
  bqf_spec,
  spectre_spec,
  subversive_spec,
  vim_abolish_spec,
}
