local leap_keys = {
  { "n", "<C-m>", "<plug>(leap-forward-to)", { desc = "Leap: Forward to" } },
  { "n", "<C-n>", "<plug>(leap-backward-to)", { desc = "Leap: Backward to" } },
  { "n", "gs", "<plug>(leap-cross-window)", { desc = "Leap: Across all windows" } },
}

return {{
  "ggandor/leap.nvim",
  event = "VeryLazy",
  keys = fignvim.mappings.make_lazy_keymaps(leap_keys, true),
}
}