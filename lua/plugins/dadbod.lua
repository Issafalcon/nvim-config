vim.pack.add({
  {
    src = "https://github.com/tpope/vim-dadbod",
  },
  {
    src = "https://github.com/kristijanhusak/vim-dadbod-ui",
  },
  {
    src = "https://github.com/kristijanhusak/vim-dadbod-completion",
  },
})

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_save_location = "~/.config/nvim/db_ui"

vim.keymap.set("n", "<leader>Du", ":DBUIToggle<CR>", { desc = "Dadbod UI: Toggle" })
vim.keymap.set("n", "<leader>Df", ":DBUIFindBuffer<CR>", { desc = "Dadbod UI: Fine Buffer" })
vim.keymap.set("n", "<leader>Dr", ":DBUIRenameBuffer<CR>", { desc = "Dadbod UI: Rename Buffer" })
vim.keymap.set("n", "<leader>Dl", ":DBUILastQueryInfo<CR>", { desc = "Dadbod UI: Last query info" })
