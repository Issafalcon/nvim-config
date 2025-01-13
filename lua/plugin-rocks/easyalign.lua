local easy_align_keys = {
  {
    { "n", "x" },
    "ga",
    "<Plug>(EasyAlign)",
    { desc = "Easy align in visual mode, or for a motion" },
  },
}

fignvim.mappings.create_keymaps(easy_align_keys)
