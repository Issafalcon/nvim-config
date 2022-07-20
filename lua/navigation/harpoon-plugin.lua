local map = vim.keymap.set
local map_opts = { noremap = true, silent = true }

require("harpoon").setup({
  global_settings = {
    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
    tmux_autoclose_windows = false, }
})

-- Keymaps

map({"n"}, "<leader>ja", ":lua require('harpoon.mark').add_file()<cr>", map_opts)
map({"n"}, "<leader>jm", ":lua require('harpoon.ui').toggle_quick_menu()<cr>", map_opts)
map({"n"}, "1", ":lua require('harpoon.ui').nav_file(1)<cr>", map_opts)
map({"n"}, "2", ":lua require('harpoon.ui').nav_file(2)<cr>", map_opts)
map({"n"}, "3", ":lua require('harpoon.ui').nav_file(3)<cr>", map_opts)
map({"n"}, "4", ":lua require('harpoon.ui').nav_file(4)<cr>", map_opts)
map({"n"}, "t1", ":lua require('harpoon.term').gotoTerminal(1)<cr>", map_opts)
map({"n"}, "t2", ":lua require('harpoon.term').gotoTerminal(2)<cr>", map_opts)
map({"n"}, "t3", ":lua require('harpoon.term').gotoTerminal(3)<cr>", map_opts)
map({"n"}, "t4", ":lua require('harpoon.term').gotoTerminal(4)<cr>", map_opts)
