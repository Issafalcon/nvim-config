local cheatsheet_keys = {
  { "n", "<leader>?", ":Cheatsheet<CR>", { desc = "Toggles Cheatsheet help window in Telescope" } },
}

return {
  {
    "sudormrfbin/cheatsheet.nvim",
    keys = fignvim.mappings.make_lazy_keymaps(cheatsheet_keys, true),
    config = true,
  },
}
