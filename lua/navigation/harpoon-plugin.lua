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
map({"n"}, "<leader>1", ":lua require('harpoon.ui').nav_file(1)<cr>", map_opts)
map({"n"}, "<leader>2", ":lua require('harpoon.ui').nav_file(2)<cr>", map_opts)
map({"n"}, "<leader>3", ":lua require('harpoon.ui').nav_file(3)<cr>", map_opts)
map({"n"}, "<leader>4", ":lua require('harpoon.ui').nav_file(4)<cr>", map_opts)
map({"n"}, "<leader>5", ":lua require('harpoon.ui').nav_file(5)<cr>", map_opts)
map({"n"}, "<leader>6", ":lua require('harpoon.ui').nav_file(6)<cr>", map_opts)
map({"n"}, "<leader>7", ":lua require('harpoon.ui').nav_file(7)<cr>", map_opts)
map({"n"}, "<leader>8", ":lua require('harpoon.ui').nav_file(8)<cr>", map_opts)
map({"n"}, "<leader>9", ":lua require('harpoon.ui').nav_file(9)<cr>", map_opts)
map({"n"}, "<leader>0", ":lua require('harpoon.ui').nav_file(10)<cr>", map_opts)
map({"n"}, "t1", ":lua require('harpoon.term').gotoTerminal(1)<cr>", map_opts)
map({"n"}, "t2", ":lua require('harpoon.term').gotoTerminal(2)<cr>", map_opts)
map({"n"}, "t3", ":lua require('harpoon.term').gotoTerminal(3)<cr>", map_opts)
map({"n"}, "t4", ":lua require('harpoon.term').gotoTerminal(4)<cr>", map_opts)
