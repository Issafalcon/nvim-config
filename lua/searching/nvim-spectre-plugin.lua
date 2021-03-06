local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<leader>S", ":lua require('spectre').open()<CR>", opts)

-- Search current word
keymap("n", "<leader>sw", ":lua require('spectre').open_visual({select_word=true})<CR>", opts)

keymap("v", "<leader>s", ":lua require('spectre').open_visual()<CR>", opts)
keymap("n", "<leader>sp", "viw:lua require('spectre').open_file_search()<CR>", opts)

require('spectre').setup({

  color_devicons = true,
  open_cmd = 'vnew',
  live_update = true, -- auto excute search again when you write any file in vim
  line_sep_start = '┌-----------------------------------------',
  result_padding = '¦  ',
  line_sep       = '└-----------------------------------------',
  mapping={
    ['toggle_line'] = {
        map = "dd",
        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
        desc = "toggle current item"
    },
    ['enter_file'] = {
        map = "<cr>",
        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
        desc = "goto current file"
    },
    ['send_to_qf'] = {
        map = "<leader>q",
        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
        desc = "send all item to quickfix"
    },
    ['replace_cmd'] = {
        map = "<leader>c",
        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
        desc = "input replace vim command"
    },
    ['show_option_menu'] = {
        map = "<leader>o",
        cmd = "<cmd>lua require('spectre').show_options()<CR>",
        desc = "show option"
    },
    ['run_replace'] = {
        map = "<leader>R",
        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
        desc = "replace all"
    },
    ['change_view_mode'] = {
        map = "<leader>v",
        cmd = "<cmd>lua require('spectre').change_view()<CR>",
        desc = "change result view mode"
    },
    ['toggle_live_update']={
      map = "tu",
      cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
      desc = "update change when vim write file."
    },
    ['toggle_ignore_case'] = {
      map = "ti",
      cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
      desc = "toggle ignore case"
    },
    ['toggle_ignore_hidden'] = {
      map = "th",
      cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
      desc = "toggle search hidden"
    },
    -- you can put your mapping here it only use normal mode
  }
})


