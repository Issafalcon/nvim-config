local session_lens_keys = {
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

return {
  {
    "tpope/vim-dadbod",
    keys = fignvim.mappings.make_lazy_keymaps(session_lens_keys, true),
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    init = function()
      fignvim.config.set_vim_opts({
        g = {
          db_ui_save_location = "~/.config/nvim/db_ui",
        },
      })
    end,
  },
}
