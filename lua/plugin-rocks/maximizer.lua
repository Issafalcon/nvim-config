local maximizer_keys = {
  {
    "n",
    "<leader>m",
    ":MaximizerToggle!<CR>",
    { desc = "Toggle maximizer (current window)" },
  },
}

fignvim.mappings.create_keymaps(maximizer_keys)
