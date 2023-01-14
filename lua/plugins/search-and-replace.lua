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

return {
  bqf_spec,
  spectre_spec,
}
