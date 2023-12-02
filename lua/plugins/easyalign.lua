local easy_align_keys = {
  { { "n", "x" }, "ga", "<Plug>(EasyAlign)", { desc = "Easy align in visual mode, or for a motion" } },
}

return {
  {
    "junegunn/vim-easy-align",
    keys = fignvim.mappings.make_lazy_keymaps(easy_align_keys, true),
  },
}
