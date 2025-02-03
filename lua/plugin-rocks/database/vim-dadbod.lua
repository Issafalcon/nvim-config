local dadbod_keys = {
  {
    "n",
    "<leader>Du",
    ":DBUIToggle<CR>",
    { desc = "Dadbod UI: Toggle" },
  },
  {
    "n",
    "<leader>Df",
    ":DBUIFindBuffer<CR>",
    { desc = "Dadbod UI: Fine Buffer" },
  },
  {
    "n",
    "<leader>Dr",
    ":DBUIRenameBuffer<CR>",
    { desc = "Dadbod UI: Rename Buffer" },
  },
  {
    "n",
    "<leader>Dl",
    ":DBUILastQueryInfo<CR>",
    { desc = "Dadbod UI: Last query info" },
  },
}

fignvim.config.set_vim_opts({
  g = {
    db_ui_save_location = "~/.config/nvim/db_ui",
    db_ui_use_nerd_fonts = true,
  },
})

fignvim.mappings.create_keymaps(dadbod_keys)
