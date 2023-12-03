-- Enhanced join / split functionality
local treesj_keys = {
  { "n", "<leader>j", "<cmd>TSJToggle<cr>", { desc = "Join Toggle" } },
}

return {
  {
    "Wansmer/treesj",
    keys = fignvim.mappings.make_lazy_keymaps(treesj_keys, true),
    opts = { use_default_keymaps = false, max_join_length = 140 },
  },
}
