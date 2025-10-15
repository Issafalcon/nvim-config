local maximizer_keys = {
  { "n", "<leader>m", ":MaximizerToggle!<CR>", { desc = "Toggle maximizer (current window)" } },
}

return {
  {
    "szw/vim-maximizer",
    cmd = "MaximizerToggle",
    keys = fignvim.mappings.make_lazy_keymaps(maximizer_keys, true),
  },
}
